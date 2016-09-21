require 'spec_helper'
require 'roly_poly/shared_examples/shared_examples_for_roles'

describe RolyPoly do

  context 'using default models' do
    before(:all) { reset_config }

    it_behaves_like RolyPoly::HasRoles
  end

end
