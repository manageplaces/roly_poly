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
      subject { adapter.find_role_by_name(:role_name) }
      it { should eq(nil) }
    end

    context 'with a role' do

      context 'specify name as symbol' do
        subject { adapter.find_role_by_name(:admin) }
        it { should_not eq(nil) }
        it { should eq(admin_role) }
      end

      context 'specify name as string' do
        subject { adapter.find_role_by_name('admin') }
        it { should_not eq(nil) }
        it { should eq(admin_role) }
      end

      context 'specify different case name' do
        subject { adapter.find_role_by_name('ADMIN') }
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

end
