require 'spec_helper'
require 'roly_poly/adapters/active_record/resource_adapter'

describe RolyPoly::Adapters::ResourceAdapter do

  let(:admin_role) { Role.first }
  let(:adapter) { RolyPoly::Adapters::ResourceAdapter.new }
  let(:group) { Group.first }
  let(:group2) { Group.last }
  let(:user) { User.first }
  let(:user2) { User.last }

  context 'find by permission', scope: :unrestricted do

    before(:each) {
      user.add_permission(:user_permission_a, Group.first)
      user.add_permission(:user_permission_b, Forum.first)
      user.add_role(:god, Group.first)
    }

    it 'should return an empty array for a non existent permission' do
      expect(adapter.resources_find_by_permission(Company, :no_permission)).to eq([])
    end

    context 'without a user' do
      it 'should return all groups with the permission assigned against it' do
        expect(adapter.resources_find_by_permission(Group, :user_permission_a)).to eq([group])
      end

      it 'should return all groups with the permission contained in a role assigned against it' do
        expect(adapter.resources_find_by_permission(Group, :view_user)).to eq([group])
      end

      it 'should return an empty array if there are no permissions' do
        expect(adapter.resources_find_by_permission(Group, :user_permission_b)).to eq([])
      end
    end

    context 'with a user' do
      it 'should return no groups if the user is not assigned that permission' do
        expect(adapter.resources_find_by_permission(Group, :user_permission_a, user2)).to eq([])
      end

      it 'should return all groups with the permission assigned against it for the specified user' do
        expect(adapter.resources_find_by_permission(Group, :user_permission_a, user)).to eq([group])
      end
    end
  end

  context 'find by role' do

    before(:each) {
      user.add_role(:god, group)
      user.add_role(:manager, group2)
    }

    it 'should return an empty array for a non existent permission' do
      expect(adapter.resources_find_by_role(Company, :no_permission)).to eq([])
    end

    context 'without a user' do
      it 'should return all groups with the god role assigned against it' do
        expect(adapter.resources_find_by_role(Group, :god)).to eq([group])
      end

      it 'should return an empty array if there are no roles' do
        expect(adapter.resources_find_by_role(Group, :superhero)).to eq([])
      end
    end

    context 'with a user' do
      it 'should return no groups if the user is not assigned that role' do
        expect(adapter.resources_find_by_role(Group, :god, user2)).to eq([])
      end

      it 'should return all groups with the role assigned against it for the specified user' do
        expect(adapter.resources_find_by_role(Group, :god, user)).to eq([group])
      end
    end
  end

end
