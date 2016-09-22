require 'roly_poly/shared_contexts'
require 'roly_poly/shared_examples/shared_examples_for_finders'
require 'roly_poly/shared_examples/grants/shared_examples_for_add_roles'
require 'roly_poly/shared_examples/grants/shared_examples_for_remove_roles'
require 'roly_poly/shared_examples/grants/shared_examples_for_has_role'
require 'roly_poly/shared_examples/grants/shared_examples_for_has_permission'

shared_examples_for RolyPoly::HasRoles do
  let(:mappings) { RolyPoly.class_mappings }
  let(:user_class) { mappings[:user][:klass] }
  let(:user) { user_class.create(name: 'Admin user') }

  before(:all) do
    reset_config
  end

  context 'role model instances' do

    subject { user }

    [ :add_role, :grant, :grant_role, :assign_role ].each do |method_alias|
      it { should respond_to(method_alias.to_sym).with(1).arguments }
      it { should respond_to(method_alias.to_sym).with(2).arguments }
    end

    [ :has_role?, :is_assigned_role? ].each do |method_alias|
      it { should respond_to(method_alias.to_sym).with(1).arguments }
      it { should respond_to(method_alias.to_sym).with(2).arguments }
    end

    it { should respond_to(:has_permission?).with(1).arguments }
    it { should respond_to(:has_permission?).with(2).arguments }

    [ :remove_role, :revoke, :revoke_role, :unassign_role ].each do |method_alias|
      it { should respond_to(method_alias.to_sym).with(1).arguments }
      it { should respond_to(method_alias.to_sym).with(2).arguments }
    end


    describe '#add_role' do
      it_should_behave_like '#add_role_examples', 'String', :to_s
      it_should_behave_like '#add_role_examples', 'Symbol', :to_sym
    end

    describe '#remove_role' do
      it_should_behave_like '#remove_role_examples', 'String', :to_s
      it_should_behave_like '#remove_role_examples', 'Symbol', :to_sym
    end

    describe '#has_role?' do
      it_should_behave_like '#has_role?_examples', 'String', :to_s
      it_should_behave_like '#has_role?_examples', 'Symbol', :to_sym
    end

    describe '#has_permission?' do
      it_should_behave_like '#has_permission?_examples', 'String', :to_s
      it_should_behave_like '#has_permission?_examples', 'Symbol', :to_sym
    end
  end
end
