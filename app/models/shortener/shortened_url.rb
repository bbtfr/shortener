class Shortener::ShortenedUrl < ActiveRecord::Base

  URL_PROTOCOL_HTTP = "http://"
  REGEX_LINK_HAS_PROTOCOL = Regexp.new('\Ahttp:\/\/|\Ahttps:\/\/', Regexp::IGNORECASE)

  attr_accessible :url
  validates :url, :presence => true
  validate :bad_uri

  # allows the shortened link to be associated with a user
  belongs_to :owner, :polymorphic => true
  has_many :shortened_clicks, :class_name=>'Shortener::ShortenedClick'

  def bad_uri
    self.url = self.class.clean_url url
  rescue URI::InvalidURIError
    errors.add(:url, "invalid (is not URI?)")
  end

  # ensure the url starts with it protocol and is normalized
  def self.clean_url url
    return nil if url.blank?
    url = URL_PROTOCOL_HTTP + url.strip unless url =~ REGEX_LINK_HAS_PROTOCOL
    URI.parse(url).normalize.to_s
  end

  # return shortened url on success, nil on failure
  def self.generate!(orig_url, args = {})
    orig_url = generate(orig_url, args)
    return nil if orig_url.new_record? and not orig_url.save
    orig_url
  end

  # return shortened url without saving
  def self.generate(orig_url, args = {})
    args = args.with_indifferent_access
    # if we get a shortened_url object with a different owner, generate
    # new one for the new owner. Otherwise return same object
    case orig_url
    when Shortener::ShortenedUrl
      if args.find { |key, value| value != orig_url.send(key) }
        args[:url] = orig_url.url
      else
        return orig_url
      end
    when String
      args[:url] = orig_url
    when Hash
      args.merge! orig_url
    end
    # don't want to generate the link if it has already been generated
    # so check the datastore
    owner = args.delete :owner
    scope = owner ? owner.shortened_urls : self

    begin
      args[:url] = clean_url(args[:url])
      return scope.where(args).first_or_initialize
    rescue URI::InvalidURIError
      return scope.new(args)
    end
  end

  # track how many times the link has been clicked, etc
  def track env
    # don't want to wait for the increment to happen, make it snappy!
    # this is the place to enhance the metrics captured
    # for the system. You could log the request origin
    # browser type, ip address etc.
    tracking = Proc.new do
      increment!(:use_count)
      click = shortened_clicks.new
      click.track env
      click.save

      # if Shortener.tracking_with_new_thread
        ActiveRecord::Base.connection.close
      # end
    end

    if Shortener.tracking_with_new_thread
      Thread.new &tracking
    else
      tracking.call
    end
  end

  # details
  # analyze clicks
  def analyze_clicks(type = :month)
    options = {
      month: {
        since: DateTime.now - 2.year,
        group_by: :all_months_until,
        step: :beginning_of_month,
      }
    }

    since = options[type][:since]
    step = options[type][:step]
    group_by = options[type][:group_by]

    ret = {}

    grouped_clicks = shortened_clicks.where(["created_at > ?", since]).group_by do |click|
      click.created_at.send(step).to_i
    end

    since.send(group_by, DateTime.now).each do |date|
      timestamp = date.to_i
      clicks = grouped_clicks[timestamp]
      ret[date] = if clicks then clicks.length else 0 end
    end

    ret
  end

  # analyze
  def analyze attribute
    ret = {}

    shortened_clicks.each do |click|
      key = click.send(attribute) 
      key = 'Unknown' if key.blank?
      ret[key] = ret.fetch(key, 0) + 1
    end

    ret
  end

  private

  # we'll rely on the DB to make sure the unique key is really unique.
  # if it isn't unique, the unique index will catch this and raise an error
  def create
    count = 0
    self.unique_key ||= generate_unique_key
    begin
      super
    rescue ActiveRecord::RecordNotUnique, ActiveRecord::StatementInvalid => err
      if (count +=1) < 5
        logger.info("  #{err}")
        logger.info("  Retrying with different unique key")
        self.unique_key = generate_unique_key
        retry
      else
        logger.info("  Too many retries, giving up")
        raise
      end
    end
  end

  # generate a random string
  # future mod to allow specifying a more expansive charst, like utf-8 chinese
  def generate_unique_key
    # not doing uppercase as url is case insensitive
    charset = ::Shortener.key_chars
    (0...::Shortener.unique_key_length).map{ charset[rand(charset.size)] }.join
  end
end

class DateTime
  def all_months_until to
    from = self
    from, to = to, from if from > to
    m = DateTime.new from.year, from.month
    result = []
    while m <= to
      result << m
      m >>= 1
    end

    result
  end
end