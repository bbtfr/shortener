Shortener::Engine.routes.draw do
  resources :shortened_urls
  root :to => "shortened_urls#index"
end
