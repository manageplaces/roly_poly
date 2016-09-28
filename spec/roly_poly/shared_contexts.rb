shared_context 'global role', scope: :one_per_user do
  subject { admin }

  def admin
    RolyPoly.class_mappings[:user][:klass].find_by_name('admin')
  end

  before(:all) do
    RolyPoly.role_exclusivity = :one_per_user
    load_roles
  end

  def load_roles
    RolyPoly.class_mappings[:user_privilege][:klass].destroy_all
    admin.add_role(:admin)
  end

end

shared_context 'class scoped role', scope: :one_per_resource do

  subject { moderator }

  def moderator
    RolyPoly.class_mappings[:user][:klass].find_by_name('moderator')
  end

  before(:all) do
    RolyPoly.role_exclusivity = :one_per_resource
    load_roles
  end

  def load_roles
    RolyPoly.class_mappings[:user_privilege][:klass].destroy_all
    moderator.add_role(:admin)
    moderator.add_role(:manager, Group)
    moderator.add_role(:moderator, Forum.first)
    moderator.add_role(:moderator, Group.first)
  end

end

shared_context 'instance scoped role', scope: :unrestricted do

  subject { manager }

  def manager
    RolyPoly.class_mappings[:user][:klass].find_by_name('manager')
  end

  before(:all) do
    RolyPoly.role_exclusivity = :unrestricted
    load_roles
    assign_permissions
  end

  def load_roles
    RolyPoly.class_mappings[:user_privilege][:klass].destroy_all
    manager.add_role(:superhero)
    manager.add_role(:manager)
    manager.add_role(:god, Group)
    manager.add_role(:manager, Group)
    manager.add_role(:manager, Group.first)
    manager.add_role(:moderator, Forum.first)
    manager.add_role(:moderator, Group.first)

    manager.add_role({ name: :company_superhero, resource: Company.first })
    manager.add_role({ name: :company_manager, resource: Company.first })
    manager.add_role({ name: :company_god, resource: Company.first }, Group)
    manager.add_role({ name: :company_manager, resource: Company.first }, Group)
    manager.add_role({ name: :company_manager, resource: Company.first }, Group.first)
    manager.add_role({ name: :company_moderator, resource: Company.first }, Forum.first)
    manager.add_role({ name: :company_moderator, resource: Company.first }, Group.first)
  end

  let!(:role_class) { RolyPoly.class_mappings[:role][:klass] }
  let!(:permission_class) { RolyPoly.class_mappings[:permission][:klass] }
  let!(:company) { Company.first }

  def assign_permissions
    manager_role = RolyPoly.class_mappings[:role][:klass].find_by_name('manager')
    superhero_role = RolyPoly.class_mappings[:role][:klass].find_by_name('superhero')
    god_role = RolyPoly.class_mappings[:role][:klass].find_by_name('god')
    moderator_role = RolyPoly.class_mappings[:role][:klass].find_by_name('moderator')

    superhero_role.add_permission(:update_user)
    god_role.add_permission(:view_user)
    moderator_role.add_permission(:create_user)
  end
end


shared_context 'class', scope: :class do
  subject { user_class }

  before(:all) {
    RolyPoly.class_mappings[:user_privilege][:klass].destroy_all
  }

  def user_class
    RolyPoly.class_mappings[:user][:klass]
  end

  let!(:admin) { provision_user(user_class.find_by_name('admin'), [ :admin, [ :moderator, Group ], [ :moderator, Forum ], [ :manager, Forum.first ], [ :teammember, Forum.last ] ]) }
  let!(:moderator) { provision_user(user_class.find_by_name('moderator'), [ [ :moderator, Forum ], [ :manager, Group ], [ :moderator, Group.last ] ]) }
  let!(:manager) { provision_user(user_class.find_by_name('manager'), [[ :moderator, Forum.first ]])}
end
