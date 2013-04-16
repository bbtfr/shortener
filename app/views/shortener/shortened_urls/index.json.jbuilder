json.array!(@shortened_urls) do |shortened_url|
  json.extract! shortened_url, :id, :url, :use_count
  json.short_url short_url(shortened_url)
  json.create shortened_url.created_at.strftime '%F'
end