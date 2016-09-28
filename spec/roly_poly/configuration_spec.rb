require 'spec_helper'

describe RolyPoly do

  before(:each) { reset_config }
  before(:all) do
    class DiffUser; end
    class DiffRole; end
    class DiffPermission; end
    class DiffUserPrivilege; end
    class DiffRoleDiffPermission; end
    class DiffRolePermission; end
  end

  describe :default_values do

    context 'user class name' do
      subject { RolyPoly.user_class_name }
      it { should eq('User') }
    end

    context 'role class name' do
      subject { RolyPoly.role_class_name }
      it { should eq('Role') }
    end

    context 'permission class name' do
      subject { RolyPoly.permission_class_name }
      it { should eq('Permission') }
    end

    context "orm" do
      subject { RolyPoly.orm }
      it { should eq('active_record') }
    end

    context 'role exclusivity' do
      subject { RolyPoly.role_exclusivity }
      it { should eq(:one_per_resource) }
    end

    context 'role exclusivity error' do
      subject { RolyPoly.role_exclusivity_error }
      it { should eq(:raise) }
    end
  end

  describe :custom_values do
    context 'using the configure method' do
      before(:each) do
        RolyPoly.configure do |config|
          config.user_class_name = 'DiffUser'
          config.role_class_name = 'DiffRole'
          config.permission_class_name = 'DiffPermission'
          config.role_exclusivity = :one_per_user
          config.role_exclusivity_error = :ignore
        end
      end

      context 'user class name' do
        subject { RolyPoly.user_class_name }
        it { should eq('DiffUser') }
      end

      context 'role class name' do
        subject { RolyPoly.role_class_name }
        it { should eq('DiffRole') }
      end

      context 'permission class name' do
        subject { RolyPoly.permission_class_name }
        it { should eq('DiffPermission') }
      end

      context 'role exclusivity' do
        subject { RolyPoly.role_exclusivity }
        it { should eq(:one_per_user) }
      end

      context 'role exclusivity error' do
        subject { RolyPoly.role_exclusivity_error }
        it { should eq(:ignore) }
      end
    end

    context 'using setters directly' do
      before(:each) do
        RolyPoly.user_class_name = 'DiffUser'
        RolyPoly.role_class_name = 'DiffRole'
        RolyPoly.permission_class_name = 'DiffPermission'
        RolyPoly.role_exclusivity = :one_per_user
        RolyPoly.role_exclusivity_error = :ignore
      end

      context 'user class name' do
        subject { RolyPoly.user_class_name }
        it { should eq('DiffUser') }
      end

      context 'role class name' do
        subject { RolyPoly.role_class_name }
        it { should eq('DiffRole') }
      end

      context 'permission class name' do
        subject { RolyPoly.permission_class_name }
        it { should eq('DiffPermission') }
      end

      context 'role exclusivity' do
        subject { RolyPoly.role_exclusivity }
        it { should eq(:one_per_user) }
      end

      context 'role exclusivity error' do
        subject { RolyPoly.role_exclusivity_error }
        it { should eq(:ignore) }
      end
    end

    context 'role exclusivity' do
      before(:each) do
        RolyPoly.role_exclusivity = :invalid_option
      end

      subject { RolyPoly.role_exclusivity }
      it { should eq(:one_per_resource) }
    end

    context 'role exclusivity error' do
      before do
        RolyPoly.role_exclusivity_error = :invalid_option
      end

      subject { RolyPoly.role_exclusivity_error }
      it { should eq(:raise) }
    end
  end

  context 'class mappings' do

    context 'default classes' do

      context 'user class mapping' do
        subject { RolyPoly.class_mappings[:user] }

        it { should_not eq(nil) }
        it { should eq({
              klass: User,
              foreign_key: :user_id,
              relation_name: :user,
              plural_relation_name: :users
            })
        }
      end

      context 'role class mapping' do
        subject { RolyPoly.class_mappings[:role] }

        it { should_not eq(nil) }
        it { should eq({
              klass: Role,
              foreign_key: :role_id,
              relation_name: :role,
              plural_relation_name: :roles
            })
        }
      end

      context 'permission class mapping' do
        subject { RolyPoly.class_mappings[:permission] }

        it { should_not eq(nil) }
        it { should eq({
              klass: Permission,
              foreign_key: :permission_id,
              relation_name: :permission,
              plural_relation_name: :permissions
            })
        }
      end

      context 'role permission class mapping' do
        subject { RolyPoly.class_mappings[:role_permission] }

        it { should_not eq(nil) }
        it { should eq({
              klass: RolePermission,
              foreign_key: :role_permission_id,
              relation_name: :role_permission,
              plural_relation_name: :role_permissions
            })
        }
      end

      context 'user privilege class mapping' do
        subject { RolyPoly.class_mappings[:user_privilege] }

        it { should_not eq(nil) }
        it { should eq({
              klass: UserPrivilege,
              foreign_key: :user_privilege_id,
              relation_name: :user_privilege,
              plural_relation_name: :user_privileges
            })
        }
      end

    end

    context 'custom classes' do

      before(:each) do
        RolyPoly.user_class_name = 'DiffUser'
        RolyPoly.role_class_name = 'DiffRole'
        RolyPoly.permission_class_name = 'DiffPermission'
      end

      context 'diff user class mapping' do
        subject { RolyPoly.class_mappings[:user] }

        it { should_not eq(nil) }
        it { should eq({
              klass: DiffUser,
              foreign_key: :diff_user_id,
              relation_name: :diff_user,
              plural_relation_name: :diff_users
            })
        }
      end

      context 'role class mapping' do
        subject { RolyPoly.class_mappings[:role] }

        it { should_not eq(nil) }
        it { should eq({
              klass: DiffRole,
              foreign_key: :diff_role_id,
              relation_name: :diff_role,
              plural_relation_name: :diff_roles
            })
        }
      end

      context 'permission class mapping' do
        subject { RolyPoly.class_mappings[:permission] }

        it { should_not eq(nil) }
        it { should eq({
              klass: DiffPermission,
              foreign_key: :diff_permission_id,
              relation_name: :diff_permission,
              plural_relation_name: :diff_permissions
            })
        }
      end

      context 'role permission class mapping' do
        subject { RolyPoly.class_mappings[:role_permission] }

        it { should_not eq(nil) }
        it { should eq({
              klass: DiffRoleDiffPermission,
              foreign_key: :diff_role_diff_permission_id,
              relation_name: :diff_role_diff_permission,
              plural_relation_name: :diff_role_diff_permissions
            })
        }
      end

      context 'user privilege class mapping' do
        subject { RolyPoly.class_mappings[:user_privilege] }

        it { should_not eq(nil) }
        it { should eq({
              klass: DiffUserPrivilege,
              foreign_key: :diff_user_privilege_id,
              relation_name: :diff_user_privilege,
              plural_relation_name: :diff_user_privileges
            })
        }
      end

    end

  end

end
