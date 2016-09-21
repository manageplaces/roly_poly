module RolyPoly
  module Finders
    extend ActiveSupport::Concern

    class_methods do

      def with_role(role, resource = nil)
        self.adapter.with_role(this, role, resource)
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
