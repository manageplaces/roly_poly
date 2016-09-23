module RolyPoly
  module Finders
    extend ActiveSupport::Concern

    module ClassMethods

      def with_role(role, resource = nil)
        self.adapter.role_scope(self, { role: role, resource: resource })
      end

      def with_all_roles(*args)
      end

      def with_any_role(*args)
      end

      def with_permission(role, resource = nil)
      end

      def with_all_permissions(*args)
      end

      def with_any_permission(*args)
      end

    end

  end
end
