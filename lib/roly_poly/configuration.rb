module RolyPoly
  module Configuration

    @@user_class_name = 'User'
    @@role_class_name = 'Role'
    @@permission_class_name = 'Permission'


    def configure
      yield self if block_given?
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

  end
end
