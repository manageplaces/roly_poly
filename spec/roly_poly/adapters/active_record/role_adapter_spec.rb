require 'spec_helper'
require 'roly_poly/adapters/active_record/role_adapter'

describe RolyPoly::Adapters::RoleAdapter do

  class User < ActiveRecord::Base
    has_roles
  end

  let(:admin_role) { Role.first }
  let(:adapter) { RolyPoly::Adapters::RoleAdapter.new }

  context 'get user role' do

    context 'without role' do
      subject { adapter.find_role(:role_name) }
      it { should eq(nil) }
    end

    context 'with a role' do

      context 'specify name as symbol' do
        subject { adapter.find_role(:admin) }
        it { should_not eq(nil) }
        it { should eq(admin_role) }
      end

      context 'specify name as string' do
        subject { adapter.find_role('admin') }
        it { should_not eq(nil) }
        it { should eq(admin_role) }
      end

      context 'specify different case name' do
        subject { adapter.find_role('ADMIN') }
        it { should eq(nil) }
      end

    end

  end

  context 'add role' do
    let(:user) { User.create(name: 'Admin user') }
    let(:role) { Role.create(name: 'admin') }

    it 'should create a user_role in the user_roles table' do
      expect { adapter.add(user, role) }.to change { UserRole.count }.by(1)
    end

  end

  context 'get roles' do
    let(:user) { User.create(name: 'admin user') }
    let(:role1) { Role.find_by_name('admin') }
    let(:role2) { Role.find_by_name('moderator') }
    let(:role3) { Role.find_by_name('manager') }

    before(:each) {
      user.add_role(:admin)
      user.add_role(:moderator, Forum)
      user.add_role(:manager, Forum.first)
    }

    it 'should return the global scoped role' do
      expect(adapter.roles(user)).to include(role1)
    end

    it 'should return the class scoped role' do
      expect(adapter.roles(user, Forum)).to include(role2)
    end

    it 'should return the instance scoped role' do
      expect(adapter.roles(user, Forum.first)).to include(role3)
    end

    it 'should return all roles' do
      expect(adapter.roles(user, :any)).to include(role1, role2, role3)
    end

    it 'should return no roles' do
      expect(adapter.roles(user, Group)).to eq([])
    end

  end

  context 'has permission' do
    let(:user) { User.create(name: 'admin user') }
    let(:role1) { Role.find_by_name('admin') }
    let(:role2) { Role.find_by_name('moderator') }
    let(:role3) { Role.find_by_name('manager') }

    before(:each) {
      user.add_role(:admin)
      user.add_role(:moderator, Forum)
      user.add_role(:manager, Forum.first)

      role1.add_permission(:create_user)
      role2.add_permission(:update_user)
      role3.add_permission(:view_user)
    }

    context 'with global scoped role' do
      it 'returns true for global role' do
        expect(adapter.has_permission?(user, :create_user)).to be_truthy
      end

      it 'returns true for a class role' do
        expect(adapter.has_permission?(user, :create_user, Forum)).to be_truthy
      end

      it 'returns true for an instance role' do
        expect(adapter.has_permission?(user, :create_user, Forum.first)).to be_truthy
      end
    end

    context 'with class scoped role' do

      it 'returns false for a global role' do
        expect(adapter.has_permission?(user, :update_user)).to be_falsey
      end

      it 'returns true for a class role' do
        expect(adapter.has_permission?(user, :update_user, Forum)).to be_truthy
      end

      it 'returns true for an instance role' do
        expect(adapter.has_permission?(user, :update_user, Forum.first)).to be_truthy
      end

    end

    context 'with instance scoped role' do

      it 'returns false for a global role' do
        expect(adapter.has_permission?(user, :view_user)).to be_falsey
      end

      it 'returns false for a class role' do
        expect(adapter.has_permission?(user, :view_user, Forum)).to be_falsey
      end

      it 'returns true for an instance role' do
        expect(adapter.has_permission?(user, :view_user, Forum.first)).to be_truthy
      end

    end

    context 'with :any resource' do
      it 'has create_user permission' do
        expect(adapter.has_permission?(user, :create_user, :any)).to be_truthy
      end

      it 'has update_user permision' do
        expect(adapter.has_permission?(user, :update_user, :any)).to be_truthy
      end

      it 'has view_user permision' do
        expect(adapter.has_permission?(user, :view_user, :any)).to be_truthy
      end
    end

  end

end
