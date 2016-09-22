 require 'roly_poly/errors'

module RolyPoly
  module Grants
    extend ActiveSupport::Concern

    #
    # Adds a role to the user for the specified
    # resource.
    #
    # This method has multiple other aliases:
    #
    # - grant
    # - grant_role
    # - assign_role
    #
    def add_role(role_name, resource = nil)
      role = self.adapter.find_role_by_name(role_name.to_s)
      if role.nil?
        add_role_failure(role_name, resource, :role_not_found)
      else
        case RolyPoly.role_exclusivity
          when :one_per_user
            add_one_per_user_role(role, resource)
          when :one_per_resource
            add_one_per_resource_role(role, resource)
          when :unrestricted
            add_unrestricted_role(role, resource)
        end
      end
    end
    alias_method :grant, :add_role
    alias_method :grant_role, :add_role
    alias_method :assign_role, :add_role

    #
    # Determines whether or not the user has the
    # specified role for the specified resource
    #
    # This method also has the alias `is_assigned_role?`
    #
    def has_role?(role_name, resource = nil)
      self.adapter.where(self.send(RolyPoly.class_mappings[:user_role][:plural_relation_name]), name: role_name, resource: resource).any?
    end
    alias_method :is_assigned_role?, :has_role?


    def has_permission?(permission_name, resource = nil)
      self.adapter.has_permission?(self, permission_name, resource)
    end




    #
    # Removes the specified role scoped to the specified
    # resource if it exists.
    #
    def remove_role(role_name, resource = nil)
      role = self.adapter.find_role_by_name(role_name.to_s)
      unless role.nil?
        self.adapter.remove_role(self, role, resource)
      end
    end
    alias_method :revoke, :remove_role
    alias_method :revoke_role, :remove_role
    alias_method :unassign_role, :remove_role






    private


    #
    # Add a role to the user, with the `one_per_user` rule.
    # This will only allow one role to be assigned to the
    # user
    #
    def add_one_per_user_role(role, resource = nil)
      add_one_per_resource_role(role, :any)
    end

    #
    # Add a role to the user, with the `one_per_resource` rule.
    # This will allow many roles to be assigned to the user,
    # but only one per resource.
    #
    def add_one_per_resource_role(role, resource = nil)
      if self.adapter.has_existing_role?(self, resource)
        if RolyPoly.role_exclusivity_error == :replace
          replace_role(role, resource)
        else
          add_role_failure(role, resource, :role_assigned)
        end
      else
        self.adapter.add(self, role, resource == :any ? nil : resource)
        role
      end
    end

    #
    # Add a role to the user. There is no restriction
    # imposed on this method, except that it will not
    # add the same role multiple times.
    #
    def add_unrestricted_role(role, resource = nil)
      unless self.adapter.has_existing_role?(self, resource, role)
        self.adapter.add(self, role, resource)
        role
      end
    end


    def add_role_failure(role, resource = nil, reason)
      case RolyPoly.role_exclusivity_error
      when :raise
        raise Errors.error_for_reason(reason)
      when :ignore
        false
      end
    end

    def replace_role(role, resource = nil)
      self.adapter.replace_role(self, role, resource)
    end

  end
end
