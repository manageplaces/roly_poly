module RolyPoly
  module RoleResource
    extend ActiveSupport::Concern

    included do
      class_attribute :adapter

      has_many "#{RolyPoly.user_class_name.underscore}_privileges".to_sym, as: :resource
      self.adapter = RolyPoly::Adapters::Base.create('resource_adapter')
    end

    module ClassMethods

      def with_permission(permission, user = nil)
        self.adapter.resources_find_by_permission(self, permission, user)
      end

      def with_role(role, user = nil)
        self.adapter.resources_find_by_role(self, role, user)
      end

    end

  end
end
