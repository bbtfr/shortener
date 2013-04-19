json.partial! "info", shortened_url: @shortened_url
json.extract! @shortened_url, :created_at
json.rqr_url shortened_url_url(@shortened_url)+'.png'
json.clicks_url clicks_shortened_url_url(@shortened_url)
json.referrers_url referrers_shortened_url_url(@shortened_url)
json.browsers_url browsers_shortened_url_url(@shortened_url)
json.countries_url countries_shortened_url_url(@shortened_url)
json.platforms_url platforms_shortened_url_url(@shortened_url)
