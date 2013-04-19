json.array!(@shortened_url.analyze(:browser).to_a) do |value|
  json.label value[0]
  json.data [[value[1], value[0]]]
end
