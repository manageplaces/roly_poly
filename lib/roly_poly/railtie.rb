require 'roly_poly'
require 'rails'

module RoledUp
  class Railtie < Rails::Railtie

    initializer 'roly_poly.initialize' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.send :extend, RolyPoly
      end
    end

  end
end
