load File.dirname(__FILE__) + '/utils/active_record.rb'

extend_rspec_with_activerecord_specific_matchers
establish_connection

ActiveRecord::Base.extend RolyPoly

load File.dirname(__FILE__) + '/../schema.rb'


class User < ActiveRecord::Base
end

class Role < ActiveRecord::Base
  has_permissions

  has_many :role_permissions
  has_many :permissions, through: :role_permissions
  has_many :user_privileges, as: :privilege
  has_many :users, through: :user_privileges
  belongs_to :resource, polymorphic: true
end

class RolePermission < ActiveRecord::Base
  belongs_to :role
  belongs_to :permission
end

class Permission < ActiveRecord::Base
  has_many :role_permissions
  has_many :roles, through: :role_permissions
  has_many :user_privileges, as: :privilege
  has_many :users, through: :user_privileges
end

class UserPrivilege < ActiveRecord::Base
  belongs_to :user
  belongs_to :privilege, polymorphic: true
  belongs_to :resource, polymorphic: true
end


class Resource < ActiveRecord::Base
  role_resource
end

class Forum < ActiveRecord::Base
  role_resource
end

class Group < ActiveRecord::Base
  role_resource
end

class Company < ActiveRecord::Base
end
