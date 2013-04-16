# encoding: utf-8
Shortener.configure do |config|
  # Shortener url generate key length
  config.unique_key_length = 5

  # Character set to chose from:
  #  :alphanum     - a-z0-9     -  has about 60 million possible combos
  #  :alphanumcase - a-zA-Z0-9  -  has about 900 million possible combos
  config.charset = :alphanum

  # Matching url prefix
  config.match_url = /^\/([a-z0-9]+)\/?$/

  # No tracking on default
  config.tracking = true
  config.tracking_with_new_thread = false
end