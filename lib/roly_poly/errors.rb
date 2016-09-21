module RolyPoly
  module Errors

    def self.error_for_reason(reason)
      case reason
      when :role_not_found
        NoRoleExistsError.new('The role does not exist')
      when :role_assigned
        RoleAssignedError.new('This role has already been assigned')
      end
    end

    class NoRoleExistsError < StandardError; end
    class RoleAssignedError < StandardError; end

  end
end
