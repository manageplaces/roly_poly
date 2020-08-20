require 'roly_poly/errors'

shared_examples_for '#add_permission_examples' do |param_type, param_method|

  context "using #{param_type} as parameter" do

    context 'when permission does not exist' do
      it 'should do nothing and return false' do
        [ :ignore, :replace ].each do |setting|
          RolyPoly.role_exclusivity_error = setting
          expect { subject.add_permission 'non_existent'.send(param_method) }.not_to change { subject.permissions.count }
          expect(subject.add_permission 'non_existent'.send(param_method)).to be_falsey
        end
      end

      it 'should raise an exception' do
        RolyPoly.role_exclusivity_error = :raise
        expect { subject.add_permission 'non_existent'.send(param_method) }.to raise_error(RolyPoly::Errors::NoPermissionExistsError)
      end
    end

    context 'when permission does exist' do

      context 'global permission', scope: :unrestricted do
        it 'should assign the global permission' do
          expect { subject.add_permission 'user_permission_a'.send(param_method) }.to change { subject.permissions.count }.by(1)
        end
      end

      context 'class permission', scope: :unrestricted do
        it 'should assign the class scoped permission' do
          expect { subject.add_permission('user_permission_b'.send(param_method), Forum) }.to change { subject.permissions.count }.by(1)
        end
      end

      context 'instance permission', scope: :unrestricted do
        it 'should assign the instance scoped permission', scope: :instance do
          expect { subject.add_permission('user_permission_c'.send(param_method), Forum.first) }.to change { subject.permissions.count }.by(1)
        end
      end


      context 'additional permissions' do

        context 'unrestricted', scope: :unrestricted do

          context 'same scope' do

            it 'should not add the same permission again' do
              expect { subject.add_permission('user_permission_a'.send(param_method), Forum.first) }.to change { subject.permissions.count }.by(1)
              expect { subject.add_permission('user_permission_a'.send(param_method), Forum.first) }.not_to change { subject.permissions.count }
            end

            it 'should add another permission' do
              subject.add_permission('user_permission_a'.send(param_method), Forum.first)
              expect { subject.add_permission('user_permission_b'.send(param_method), Forum.first) }.to change { subject.permissions.count }.by(1)
            end

          end

          context 'different scope' do

            it 'should add another permission' do
              expect { subject.add_permission('user_permission_a'.send(param_method)) }.to change { subject.permissions.count }.by(1)
              expect { subject.add_permission('user_permission_a'.send(param_method), Forum) }.to change { subject.permissions.count }.by(1)
              expect { subject.add_permission('user_permission_a'.send(param_method), Forum.last) }.to change { subject.permissions.count }.by(1)
              expect { subject.add_permission('user_permission_b'.send(param_method)) }.to change { subject.permissions.count }.by(1)
              expect { subject.add_permission('user_permission_b'.send(param_method), Forum) }.to change { subject.permissions.count }.by(1)
              expect { subject.add_permission('user_permission_b'.send(param_method), Forum.last) }.to change { subject.permissions.count }.by(1)
            end

          end

        end

      end

    end

  end

end
