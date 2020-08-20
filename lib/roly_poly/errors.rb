module RolyPoly
  module Errors

    def self.error_for_reason(reason)
      case reason
      when :role_not_found
        NoRoleExistsError.new('The role does not exist')
      when :permission_not_found
        NoPermissionExistsError.new('The permission does not exist')
      when :role_assigned
        RoleAssignedError.new('This role has already been assigned')
      when :permission_assigned
        PermissionAssignedError.new('This permission has already been assigned')
      end
    end

    class NoRoleExistsError < StandardError; end
    class NoPermissionExistsError < StandardError; end
    class RoleAssignedError < StandardError; end
    class PermissionAssignedError < StandardError; end

  end
end
