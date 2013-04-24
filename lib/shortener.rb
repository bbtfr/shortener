require "active_support/dependencies"
require "active_support/configurable"

module Shortener

  autoload :ActiveRecordExtension, "shortener/active_record_extension"
  autoload :ShortenUrlInterceptor, "shortener/shorten_url_interceptor"

  CHARSETS = {
    :alphanum => ('a'..'z').to_a + (0..9).to_a,
    :alphanumcase => ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a }
  REGEXPS = {
    :alphanum => "[a-z0-9]+",
    :alphanumcase => "[a-zA-Z0-9]+" }

  include ActiveSupport::Configurable
  config_accessor :unique_key_length, :charset, :url_prefix, :tracking,
                  :tracking_with_new_thread

  # default key length: 5 characters
  self.unique_key_length = 5

  # character set to chose from:
  #  :alphanum     - a-z0-9     -  has about 60 million possible combos
  #  :alphanumcase - a-zA-Z0-9  -  has about 900 million possible combos
  self.charset = :alphanum

  # default matching url regex: /^\/([\w\d]+)$/
  self.url_prefix = "/"

  def self.clean_url_prefix
    @clean_url ||= "#{url_prefix}#{"/" unless url_prefix.end_with? "/"}"
  end

  def self.match_url
    @match_url ||= Regexp.new "^#{clean_url_prefix}(#{key_regex})/?$"
  end

  # no tracking on default
  self.tracking = true
  self.tracking_with_new_thread = true

  def self.key_chars
    CHARSETS[charset]
  end

  def self.key_regex
    REGEXPS[charset]
  end
end

# Require our railtie and engine
require "shortener/railtie"
require "shortener/engine"
