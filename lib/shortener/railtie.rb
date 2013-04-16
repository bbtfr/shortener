module Shortener
  class Railtie < ::Rails::Railtie
    initializer "shortener.register.active.record.extension" do |app|
      app.config.middleware.use "Shortener::ShortenerRedirectMiddleware"

      ActiveSupport.on_load :active_record do
        extend Shortener::ActiveRecordExtension
      end
      ActiveSupport.on_load :action_view do
        include Shortener::ShortenerHelper
      end
    end
  end
end