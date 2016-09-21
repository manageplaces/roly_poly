module RolyPoly
  module Adapters
    class Base

      def self.create(adapter)
        load "roly_poly/adapters/#{RolyPoly.orm}/#{adapter}.rb"
        RolyPoly::Adapters.const_get(adapter.camelize.to_sym).new
      end

    end

    class RoleAdapterBase

      def add(user, role)
        raise NotImplementedError.new("You must implemented add")
      end

      def has_existing_role?(user, resource = nil, role = nil)
        raise NotImplementedError.new("You must implemented has_existing_role?")
      end

      def find_role_by_name(role_name)
        raise NotImplementedError.new("You must implemented find_role_by_name")
      end

      def remove_role(user, role, resource = nil)
        raise NotImplementedError.new("You must implemented remove_role")
      end


      def replace_role(user, role)
        raise NotImplementedError.new("You must implemented replace_role")
      end

      def where(relation, *args)
        raise NotImplementedError.new("You must implemented where")
      end

      def with_role(klass, role_name, resource = nil)
        raise NotImplementedError.new("You must implemented with_role")
      end
    end

    class ResourceAdapterBase
    end

  end
end
