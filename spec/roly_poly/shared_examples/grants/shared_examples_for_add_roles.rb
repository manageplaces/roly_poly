require 'roly_poly/errors'

shared_examples_for '#add_role_examples' do |param_type, param_method|

  context "using #{param_type} as parameter" do

    context 'when role does not exist' do
      it 'should do nothing and return false' do
        [ :ignore, :replace ].each do |setting|
          RolyPoly.role_exclusivity_error = setting
          expect { subject.add_role 'non_existent'.send(param_method) }.not_to change { subject.roles.count }
          expect(subject.add_role 'non_existent'.send(param_method)).to be_falsey
        end
      end

      it 'should raise an exception' do
        RolyPoly.role_exclusivity_error = :raise
        expect { subject.add_role 'non_existent'.send(param_method) }.to raise_error(RolyPoly::Errors::NoRoleExistsError)
      end
    end

    context 'when role does exist' do


      context 'global role', scope: :unrestricted do
        it 'should assign the global role' do
          expect { subject.add_role 'teammember'.send(param_method) }.to change { subject.roles.count }.by(1)
        end
      end

      context 'class role', scope: :unrestricted do
        it 'should assign the class scoped role' do
          expect { subject.add_role('superhero'.send(param_method), Forum) }.to change { subject.roles.count }.by(1)
        end
      end

      context 'instance role', scope: :unrestricted do
        it 'should assign the instance scoped role', scope: :instance do
          expect { subject.add_role('admin'.send(param_method), Forum.first) }.to change { subject.roles.count }.by(1)
        end
      end


      context 'additional roles' do

        context 'one per user', scope: :one_per_user do

          context 'with global role' do
            it 'should return false and not assign' do
              RolyPoly.role_exclusivity_error = :ignore
              expect( subject.add_role('god'.send(param_method)) ).to be_falsey
              expect( subject.add_role('god'.send(param_method), Forum) ).to be_falsey
              expect( subject.add_role('god'.send(param_method), Forum.first) ).to be_falsey
            end

            it 'should replace the currently assigned role' do
              RolyPoly.role_exclusivity_error = :replace
              expect( subject.add_role('god'.send(param_method)) ).to be_truthy
              expect( subject.send(RolyPoly.class_mappings[:role][:plural_relation_name]).count ).to eq(1)
              expect(subject).to have_role('god'.send(param_method))
            end

            it 'should raise an exception' do
              RolyPoly.role_exclusivity_error = :raise
              expect { subject.add_role 'god'.send(param_method) }.to raise_error(RolyPoly::Errors::RoleAssignedError)
            end
          end

        end

        context 'one per resource', scope: :one_per_resource do

          context 'different scope' do

            it 'should assign a role to a class scope' do
              expect { subject.add_role('moderator'.send(param_method), Forum) }.to change { subject.roles.count }.by(1)
            end

            it 'should assign a role to a resource scope' do
              expect { subject.add_role('moderator'.send(param_method), Forum.last) }.to change { subject.roles.count }.by(1)
            end

          end

          context 'same scope' do

            context 'global scope' do
              it 'should return false and not assign' do
                RolyPoly.role_exclusivity_error = :ignore
                expect( subject.add_role('god'.send(param_method)) ).to be_falsey
              end

              it 'should replace the currently assigned role' do
                RolyPoly.role_exclusivity_error = :replace
                expect( subject.add_role('god'.send(param_method)) ).to be_truthy
                expect( subject.send(RolyPoly.class_mappings[:role][:plural_relation_name]).count ).to eq(1)
                expect( subject.has_role?('god') ).to be_truthy
              end

              it 'should raise an exception' do
                RolyPoly.role_exclusivity_error = :raise
                expect { subject.add_role('god'.send(param_method)) }.to raise_error(RolyPoly::Errors::RoleAssignedError)
              end
            end

            context 'class scope' do
              it 'should return false and not assign' do
                RolyPoly.role_exclusivity_error = :ignore
                expect( subject.add_role('god'.send(param_method), Group) ).to be_falsey
              end

              it 'should replace the currently assigned role' do
                RolyPoly.role_exclusivity_error = :replace
                expect( subject.add_role('god'.send(param_method), Group) ).to be_truthy
                expect( subject.send(RolyPoly.class_mappings[:role][:plural_relation_name]).count ).to eq(1)
                expect(subject).to have_role('god'.send(param_method), Group)
              end

              it 'should raise an exception' do
                RolyPoly.role_exclusivity_error = :raise
                expect { subject.add_role('god'.send(param_method), Group) }.to raise_error(RolyPoly::Errors::RoleAssignedError)
              end
            end

            context 'resource scope' do
              it 'should return false and not assign' do
                RolyPoly.role_exclusivity_error = :ignore
                expect( subject.add_role('god'.send(param_method), Forum.first) ).to be_falsey
              end

              it 'should replace the currently assigned role' do
                RolyPoly.role_exclusivity_error = :replace
                expect( subject.add_role('god'.send(param_method), Forum.first) ).to be_truthy
                expect( subject.send(RolyPoly.class_mappings[:role][:plural_relation_name]).count ).to eq(1)
                expect(subject).to have_role('god'.send(param_method), Forum.first)
              end

              it 'should raise an exception' do
                RolyPoly.role_exclusivity_error = :raise
                expect { subject.add_role('god'.send(param_method), Forum.first) }.to raise_error(RolyPoly::Errors::RoleAssignedError)
              end
            end

          end

        end

        context 'unrestricted', scope: :unrestricted do

          context 'same scope' do

            it 'should not add the same role again' do
              expect { subject.add_role('moderator'.send(param_method), Forum.first) }.not_to change { subject.roles.count }
            end

            it 'should add another role' do
              expect { subject.add_role('manager'.send(param_method), Forum.first) }.to change { subject.roles.count }.by(1)
            end

          end

          context 'different scope' do

            it 'should add another role' do
              expect { subject.add_role('god'.send(param_method)) }.to change { subject.roles.count }.by(1)
              expect { subject.add_role('god'.send(param_method), Forum) }.to change { subject.roles.count }.by(1)
              expect { subject.add_role('god'.send(param_method), Forum.last) }.to change { subject.roles.count }.by(1)
              expect { subject.add_role('teammember'.send(param_method)) }.to change { subject.roles.count }.by(1)
              expect { subject.add_role('teammember'.send(param_method), Forum) }.to change { subject.roles.count }.by(1)
              expect { subject.add_role('teammember'.send(param_method), Forum.last) }.to change { subject.roles.count }.by(1)
            end

          end

        end

      end

    end

  end

end
