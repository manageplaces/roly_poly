require 'spec_helper'

describe RolyPoly do

  describe :resources do
    context 'role resource types' do
      subject { RolyPoly.role_resource_types }
      it { should include("Resource", "Forum", "Group") }
    end
  end

end
