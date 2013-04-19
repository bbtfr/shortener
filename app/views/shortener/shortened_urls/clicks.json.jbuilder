json.array!([@shortened_url.analyze_clicks]) do |clicks|
  json.data clicks.map{|key, value| [key.to_i*1000,value]}
end
