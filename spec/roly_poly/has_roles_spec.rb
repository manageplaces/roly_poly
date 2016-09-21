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

    context 'user roles' do
      describe User do
        it { should have_many(:user_roles) }
      end
    end

    context 'roles' do
      describe User do
        it { should have_many(:roles).through(:user_roles) }
      end
    end



  end

end
