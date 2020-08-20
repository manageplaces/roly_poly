require 'generator_helper'

require 'generators/roly_poly/roly_poly_generator'

describe RolyPoly::Generators::RolyPolyGenerator, type: :generator do
  destination File.expand_path("../../../../tmp", __FILE__)

  before(:all) do
    prepare_destination
  end

  after(:all) do
    cleanup_files
  end


  def cleanup_files
    FileUtils.rm_rf destination_root
  end

  describe 'Without specifying the user model' do
    before {
      capture(:stdout) {
        generator.create_file "app/models/user.rb" do
          <<-RUBY
          class User < ActiveRecord::Base
          end
          RUBY
        end
      }

      require File.join(destination_root, "app/models/user.rb")
      run_generator
    }


    describe 'config/initializers/roly_poly.rb' do
      subject { file('config/initializers/roly_poly.rb') }

      it { should exist }
      it { should contain 'RolyPoly.configure do |config|'}
      it { should contain "# config.role_class_name = 'Role'" }
      it { should contain "# config.user_class_name = 'User'" }
      it { should contain "# config.permission_class_name = 'Permission'" }
      it { should contain "# config.role_exclusivity = :one_per_resource" }
      it { should contain "# config.role_exclusivity_error = :raise" }
    end

    describe 'app/models/user.rb' do
      subject { file('app/models/user.rb') }

      it { should contain /class User < ActiveRecord::Base\n  has_roles\n/ }
    end

    describe 'app/models/role.rb' do
      subject { file('app/models/role.rb') }

      it { should exist }
      it { should contain "class Role < ActiveRecord::Base" }
      it { should contain "has_many :role_permissions" }
      it { should contain "has_many :permissions, through: :role_permissions" }
      it { should contain "has_many :user_privileges, as: :privilege" }
      it { should contain "has_many :users, through: :user_privileges" }
      it { should contain "belongs_to :resource, polymorphic: true" }
      it { should contain "validates :resource_type, inclusion: { in: RolyPoly.role_resource_types, allow_nil: true }" }
      it { should contain "validates :name, uniqueness: { scope: [:resource_type, :resource_id] }" }
      it { should contain "validates :name, presence: true" }
    end

    describe 'app/models/permission.rb' do
      subject { file('app/models/permission.rb') }

      it { should exist }
      it { should contain "class Permission < ActiveRecord::Base" }
      it { should contain "has_many :role_permissions" }
      it { should contain "has_many :roles, through: :role_permissions" }
      it { should contain "has_many :user_privileges, as: :privilege" }
      it { should contain "has_many :users, through: :user_privileges" }
      it { should contain "validates :name, uniqueness: true" }
      it { should contain "validates :name, presence: true" }
    end

    describe 'app/models/role_permission.rb' do
      subject { file('app/models/role_permission.rb') }

      it { should exist }
      it { should contain "class RolePermission < ActiveRecord::Base" }
      it { should contain "belongs_to :role" }
      it { should contain "belongs_to :permission" }
      it { should contain "validates :role_id, uniqueness: { scope: :permission_id }"}
      it { should contain "validates :role, :permission, presence: true" }
    end

    describe 'app/models/user_privilege.rb' do
      subject { file('app/models/user_privilege.rb') }

      it { should exist }
      it { should contain "class UserPrivilege < ActiveRecord::Base" }
      it { should contain "belongs_to :user" }
      it { should contain "belongs_to :privilege, polymorphic: true" }
      it { should contain "belongs_to :resource, polymorphic: true" }
      it { should contain "validates :resource_type, inclusion: { in: RolyPoly.role_resource_types, allow_nil: true }" }
      it { should contain "validates :privilege_type, inclusion: { in: [ Role, Permission ]" }
      it { should contain "validates :user, :privilege, presence: true" }
      it { should contain "validates :user_id, uniqueness: { scope: [:privilege_type, :privilege_id, :resource_type, :resource_id] }"}
    end


    describe 'role migration file' do
      subject { migration_file('db/migrate/roly_poly_create_roles.rb') }

      it { should exist }
      it { should contain "create_table(:roles) do" }
    end

    describe 'permission migration file' do
      subject { migration_file('db/migrate/roly_poly_create_permissions.rb') }

      it { should exist }
      it { should contain "create_table(:permissions) do" }
    end

    describe 'role permissions migration file' do
      subject { migration_file('db/migrate/roly_poly_create_role_permissions.rb') }

      it { should exist }
      it { should contain "create_table(:role_permissions) do" }
    end

    describe 'user permission migration file' do
      subject { migration_file('db/migrate/roly_poly_create_user_privileges.rb') }

      it { should exist }
      it { should contain "create_table(:user_privileges) do" }
    end

  end





  describe 'Specifying a diferent role model' do
    before(:all) { arguments %w(NewRole) }

    before {
      capture(:stdout) {
        generator.create_file "app/models/user.rb" do
          <<-RUBY
          class User < ActiveRecord::Base
          end
          RUBY
        end
      }

      require File.join(destination_root, "app/models/user.rb")
      run_generator
    }

    describe 'config/initializers/roly_poly.rb' do
      subject { file('config/initializers/roly_poly.rb') }

      it { should exist }
      it { should contain "config.role_class_name = 'NewRole'" }
      it { should_not contain "# config.role_class_name = 'Role'"}
      it { should_not contain "# config.role_class_name = 'NewRole'"}
    end

    describe 'app/models/new_role.rb' do
      subject { file('app/models/new_role.rb') }

      it { should exist }
      it { should contain "class NewRole < ActiveRecord::Base" }
      it { should contain "has_many :new_role_permissions" }
      it { should contain "has_many :permissions, through: :new_role_permissions" }
    end

    describe 'app/models/permission.rb' do
      subject { file('app/models/permission.rb') }

      it { should exist }
      it { should contain "has_many :new_role_permissions" }
      it { should contain "has_many :new_roles, through: :new_role_permissions" }
    end

    describe 'app/models/new_role_permission.rb' do
      subject { file('app/models/new_role_permission.rb') }

      it { should exist }
      it { should contain "class NewRolePermission < ActiveRecord::Base" }
      it { should contain "belongs_to :new_role" }
      it { should contain "validates :new_role_id, uniqueness: { scope: :permission_id }"}
      it { should contain "validates :new_role, :permission, presence: true" }
    end

    describe 'app/models/user_privilege.rb' do
      subject { file('app/models/user_privilege.rb') }

      it { should exist }
      it { should contain "validates :privilege_type, inclusion: { in: [ NewRole, Permission ]" }
    end

    describe 'new role migration file' do
      subject { migration_file('db/migrate/roly_poly_create_new_roles.rb') }

      it { should exist }
      it { should contain "create_table(:new_roles) do" }
    end

    describe 'new role permissions migration file' do
      subject { migration_file('db/migrate/roly_poly_create_new_role_permissions.rb') }

      it { should exist }
      it { should contain "create_table(:new_role_permissions) do" }
    end
  end



  describe 'Specifying a diferent permission model' do
    before(:all) { arguments %w(Role NewPermission) }

    before {
      capture(:stdout) {
        generator.create_file "app/models/user.rb" do
          <<-RUBY
          class User < ActiveRecord::Base
          end
          RUBY
        end
      }

      require File.join(destination_root, "app/models/user.rb")
      run_generator
    }

    describe 'config/initializers/roly_poly.rb' do
      subject { file('config/initializers/roly_poly.rb') }

      it { should exist }
      it { should contain "config.permission_class_name = 'NewPermission'" }
      it { should_not contain "# config.permission_class_name = 'Permission'" }
      it { should_not contain "# config.permission_class_name = 'NewPermission'" }
    end

    describe 'app/models/role.rb' do
      subject { file('app/models/role.rb') }

      it { should exist }
      it { should contain "has_many :role_new_permissions" }
      it { should contain "has_many :new_permissions, through: :role_new_permissions" }
    end

    describe 'app/models/new_permission.rb' do
      subject { file('app/models/new_permission.rb') }

      it { should exist }
      it { should contain "class NewPermission < ActiveRecord::Base" }
      it { should contain "has_many :role_new_permissions" }
      it { should contain "has_many :roles, through: :role_new_permissions" }
    end

    describe 'app/models/role_new_permission.rb' do
      subject { file('app/models/role_new_permission.rb') }

      it { should exist }
      it { should contain "class RoleNewPermission < ActiveRecord::Base" }
      it { should contain "belongs_to :new_permission" }
      it { should contain "validates :role, :new_permission, presence: true" }
    end

    describe 'app/models/user_privilege.rb' do
      subject { file('app/models/user_privilege.rb') }

      it { should exist }
      it { should contain "validates :privilege_type, inclusion: { in: [ Role, NewPermission ]" }
    end

    describe 'new permission migration file' do
      subject { migration_file('db/migrate/roly_poly_create_new_permissions.rb') }

      it { should exist }
      it { should contain "create_table(:new_permissions) do" }
    end

    describe 'role new permissions migration file' do
      subject { migration_file('db/migrate/roly_poly_create_role_new_permissions.rb') }

      it { should exist }
      it { should contain "create_table(:role_new_permissions) do" }
    end
  end



  describe 'Specifying a different user model' do
    before(:all) { arguments %w(Role Permission AdminUser) }
    before {
      generator.create_file "app/models/admin_user.rb" do
        <<-RUBY
        class AdminUser < ActiveRecord::Base
        end
        RUBY
      end

      require File.join(destination_root, "app/models/admin_user.rb")
      run_generator
    }

    describe 'config/initializers/roly_poly.rb' do
      subject { file('config/initializers/roly_poly.rb') }

      it { should exist }
      it { should contain "config.user_class_name = 'AdminUser'" }
      it { should_not contain "# config.user_class_name = 'User'" }
      it { should_not contain "# config.user_class_name = 'AdminUser'" }
    end

    describe 'app/models/admin_user.rb' do
      subject { file('app/models/admin_user.rb') }

      it { should contain /class AdminUser < ActiveRecord::Base\n  has_roles\n/ }
    end

    describe 'app/models/admin_user_privilege.rb' do
      subject { file('app/models/admin_user_privilege.rb') }

      it { should exist }
      it { should contain "class AdminUserPrivilege < ActiveRecord::Base" }
      it { should contain "belongs_to :admin_user" }
      it { should contain "belongs_to :privilege, polymorphic: true" }
      it { should contain "belongs_to :resource, polymorphic: true" }
      it { should contain "validates :admin_user, :privilege, presence: true" }
      it { should contain "validates :admin_user_id, uniqueness: { scope: [:privilege_type, :privilege_id, :resource_type, :resource_id] }"}
    end


    describe 'admin user privilege migration file' do
      subject { migration_file('db/migrate/roly_poly_create_admin_user_privileges.rb') }

      it { should exist }
      it { should contain "create_table(:admin_user_privileges) do" }
    end

  end

end
