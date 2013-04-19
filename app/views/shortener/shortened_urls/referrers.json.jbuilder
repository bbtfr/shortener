json.array!(@shortened_url.analyze(:referer).to_a) do |value|
  json.label value[0]
  json.data value[1]
end
