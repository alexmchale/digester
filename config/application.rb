require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Autovoicecast
  class Application < Rails::Application

    # Don't generate assets automatically.
    config.generators do |g|
      g.assets false
      g.helper false
    end

  end
end
