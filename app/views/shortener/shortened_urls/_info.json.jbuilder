json.extract! shortened_url, :id, :url, :use_count
json.short_url short_url(shortened_url)
json.created shortened_url.created_at.strftime '%F'
json.details_url details_shortened_url_url(shortened_url)
