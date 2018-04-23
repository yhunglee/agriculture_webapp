require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AgricultureWebapp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.paths.add File.join('app', 'controllers', 'api'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app','controllers','api', '*')]

    # Error handling in transaction callbacks:
    # When you define a after_rollback or after_commit callback, you will receive a 
    # deprecation warning about this upcoming change. When you are ready, you can 
    # opt into the new behavior and remove the deprecation warning by adding following
    # configuration to your config/application.rb:
    config.active_record.raise_in_transactional_callbacks = true

    # Halting Callback Chains via throw(:abort) from guide of upgrading Rails 4.2 to Rails 5.0
    ActiveSupport.halt_callback_chains_on_return_false = false

    # Active Record belongs_to Required by Default Option from guide of upgrading Rails 4.2 to Rails 5.0
    config.active_record.belongs_to_required_by_default = true

    # Per-form CSRF Tokens from guide of upgrading Rails 4.2 to Rails 5.0
    config.action_controller.per_form_csrf_tokens = true

    # Forgery Protection with Origin Check from guide of upgrading Rails 4.2 to Rails 5.0
    config.action_controller.forgery_protection_origin_check = true

    # Support Fragment Caching in Action Mailer Views from guide of upgrading Rails 4.2 to Rails 5.0
    config.action_mailer.perform_caching = true

    # Configure SSL Options to Enable HSTS with Subdomains from guide of upgrading Rails 4.2 to Rails 5.0
    config.ssl_options = { hsts: { subdomains: true } }

    # Preserve Timezone of the Receiver from guide of upgrading Rails 4.2 to Rails 5.0
    ActiveSupport.to_time_preserves_timezone = true

  end
end
