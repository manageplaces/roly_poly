# frozen_string_literal: true

module RolyPoly
  module Configuration
    @@orm = 'active_record'
    @@user_class_name = 'User'
    @@role_class_name = 'Role'
    @@permission_class_name = 'Permission'
    @@role_exclusivity = :one_per_resource
    @@role_exclusivity_error = :raise
    @@mappings_changed = true

    @@class_mappings = {}

    def configure
      yield self if block_given?
      @@mappings_changed = true
    end

    def orm
      @@orm
    end

    def user_class_name=(name)
      @@user_class_name = name
    end

    def user_class_name
      @@user_class_name
    end

    def role_class_name=(name)
      @@role_class_name = name
    end

    def role_class_name
      @@role_class_name
    end

    def permission_class_name=(name)
      @@permission_class_name = name
    end

    def permission_class_name
      @@permission_class_name
    end

    def role_exclusivity=(exclusivity)
      if !%i[one_per_user one_per_resource unrestricted].include?(exclusivity.to_sym)
        Utils.logger.warn('Invalid `role_exclusivity` option provided. Ignoring')
      else
        @@role_exclusivity = exclusivity.to_sym
      end
    end

    def role_exclusivity
      @@role_exclusivity
    end

    def role_exclusivity_error=(error)
      if !%i[raise replace ignore].include?(error.to_sym)
        Utils.logger.warn('Invalid `role_exclusivity_error` option provided. Ignoring')
      else
        @@role_exclusivity_error = error.to_sym
      end
    end

    def role_exclusivity_error
      @@role_exclusivity_error
    end

    def class_mappings
      return @@class_mappings unless @@mappings_changed

      build_mappings
      @@mappings_changed = false
      @@class_mappings
    end

    private

    def build_mappings
      @@class_mappings[:user] = mappings_for(@@user_class_name)
      @@class_mappings[:role] = mappings_for(@@role_class_name)
      @@class_mappings[:permission] = mappings_for(@@permission_class_name)
      @@class_mappings[:role_permission] = mappings_for("#{@@role_class_name}#{@@permission_class_name}")
      @@class_mappings[:user_privilege] = mappings_for("#{@@user_class_name}Privilege")
    end

    def mappings_for(class_name)
      {
        klass: class_name.constantize,
        foreign_key: "#{class_name.underscore}_id".to_sym,
        relation_name: class_name.underscore.to_sym,
        plural_relation_name: class_name.underscore.pluralize.to_sym
      }
    end
  end
end
