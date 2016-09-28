module RolyPoly
  module Permissions
    extend ActiveSupport::Concern

    included do
      class_attribute :adapter
      self.adapter = RolyPoly::Adapters::Base.create('permission_adapter')

      has_many "#{RolyPoly.user_class_name.underscore}_privileges".to_sym, as: :privilege
    end

    def add_permission(permission_name)
      self.adapter.add_permission(self, permission_name)
    end

    def remove_permission(permission_name)
      self.adapter.remove_permission(self, permission_name)
    end

    def has_permission?(permission_name)
      self.adapter.has_permission?(self, permission_name)
    end

  end
end
