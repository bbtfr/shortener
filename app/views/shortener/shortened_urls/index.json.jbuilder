json.array!(@shortened_urls) do |shortened_url|
  json.partial! "info", shortened_url: shortened_url
end
