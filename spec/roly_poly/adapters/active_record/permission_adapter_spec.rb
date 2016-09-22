require 'spec_helper'
require 'roly_poly/adapters/active_record/permission_adapter'

describe RolyPoly::Adapters::PermissionAdapter do

  let(:adapter) { RolyPoly::Adapters::PermissionAdapter.new }

  context 'add a permission' do

    context 'non existent permission' do

      it 'should not create a permission_role record' do
        expect { adapter.add_permission(Role.first, 'invalid_permission') }.not_to change { RolePermission.count }
      end

    end

    context 'existing permission' do

      it 'should create a permission_role record' do
        expect { adapter.add_permission(Role.first, 'create_user') }.to change { RolePermission.count }.by(1)
      end

      it 'should not create a second permission_role record' do
        expect { adapter.add_permission(Role.first, 'create_user') }.to change { RolePermission.count }.by(1)
        expect { adapter.add_permission(Role.first, 'create_user') }.not_to change { RolePermission.count }
      end

    end

  end

  context 'removing a permission' do

    it 'returns true if the permission does not exist' do
      expect { adapter.remove_permission(Role.first, 'invalid_permission') }.not_to change { RolePermission.count }
      expect( adapter.remove_permission(Role.first, 'invalid_permission') ).to be_truthy
    end

    it 'return true if the permission is not assigned to the role' do
      expect { adapter.remove_permission(Role.first, 'create_user') }.not_to change { RolePermission.count }
      expect( adapter.remove_permission(Role.first, 'create_user') ).to be_truthy
    end

    it 'removes the permission' do
      Role.first.add_permission('create_user')
      expect { adapter.remove_permission(Role.first, 'create_user') }.to change { RolePermission.count }.by(-1)
    end

  end

  context 'has permission' do

    it 'returns false if the permission does not exist' do
      expect(adapter.has_permission?(Role.first, 'invalid_permission')).to be_falsey
    end

    it 'returns false if the permission exists but is not assigned' do
      expect(adapter.has_permission?(Role.first, 'create_user')).to be_falsey
    end

    it 'returns true if the permission is assigned' do
      Role.first.add_permission('create_user')
      expect(adapter.has_permission?(Role.first, 'create_user')).to be_truthy
    end

  end

end
