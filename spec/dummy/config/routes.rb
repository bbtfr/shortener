Rails.application.routes.draw do

  mount Shortener::Engine, :at => '/'

end
