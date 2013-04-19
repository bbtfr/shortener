Shortener::Engine.routes.draw do
  resources :shortened_urls do
    member do
      get :details
      get :clicks
      get :referrers
      get :browsers
      get :countries
      get :platforms
    end
  end
  root :to => "shortened_urls#index"
end
