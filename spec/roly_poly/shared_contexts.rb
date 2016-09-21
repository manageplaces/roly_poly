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
    RolyPoly.class_mappings[:user_role][:klass].destroy_all
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
    RolyPoly.class_mappings[:user_role][:klass].destroy_all
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
  end

  def load_roles
    RolyPoly.class_mappings[:user_role][:klass].destroy_all
    manager.add_role(:superhero)
    manager.add_role(:manager)
    manager.add_role(:god, Group)
    manager.add_role(:manager, Group)
    manager.add_role(:manager, Group.first)
    manager.add_role(:moderator, Forum.first)
    manager.add_role(:moderator, Group.first)
  end
end
