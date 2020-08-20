require 'spec_helper'

describe RolyPoly::HasRoles do

  class User < ActiveRecord::Base
    has_roles
  end

  context :adapter do

    subject { User.adapter.class }
    it { should eq(RolyPoly::Adapters::RoleAdapter) }

  end

  describe :associations do

    context 'user privileges' do
      describe User do
        it { should have_many(:user_privileges) }
      end
    end

    context 'roles' do
      describe User do
        it { should have_many(:roles).through(:user_privileges) }
      end
    end

    context 'permissions' do
      describe User do
        it { should have_many(:permissions).through(:user_privileges) }
      end
    end


  end

end
