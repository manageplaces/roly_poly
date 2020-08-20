shared_examples_for '#has_permission?_examples' do |param_type, param_method|

  context "using #{param_type} as parameter", scope: :unrestricted do

    context 'without a permission' do

      it 'returns false if the permission does not exist' do
        expect(subject.has_permission?('invalid_permission'.send(param_method))).to be_falsey
        expect(subject.has_permission?('invalid_permission'.send(param_method), Forum)).to be_falsey
        expect(subject.has_permission?('invalid_permission'.send(param_method), Forum.first)).to be_falsey
      end

    end

    context 'without a role' do
      let(:user) { User.new(name: 'no role user') }

      it 'returns false' do
        expect(user.has_permission?('create_user'.send(param_method))).to be_falsey
        expect(user.has_permission?('create_user'.send(param_method), Forum)).to be_falsey
        expect(user.has_permission?('create_user'.send(param_method), Forum.first)).to be_falsey
      end

      context 'directly added permissions' do

        context 'assigned a global scoped permission' do
          before(:each) {
            user.add_permission('user_permission_a'.send(param_method))
          }

          it 'returns true for a global' do
            expect(user.has_permission?('user_permission_a'.send(param_method))).to be_truthy
          end

          it 'returns true for a class' do
            expect(user.has_permission?('user_permission_a'.send(param_method), Forum)).to be_truthy
          end

          it 'returns true for an instance' do
            expect(user.has_permission?('user_permission_a'.send(param_method), Forum.first)).to be_truthy
          end
        end

        context 'assigned a class scoped permission' do
          before(:each) {
            user.add_permission('user_permission_a'.send(param_method), Forum)
          }

          it 'returns false for global' do
            expect(user.has_permission?('user_permission_a'.send(param_method))).to be_falsey
          end

          it 'returns true for a class' do
            expect(user.has_permission?('user_permission_a'.send(param_method), Forum)).to be_truthy
          end

          it 'returns false for a different class' do
            expect(user.has_permission?('user_permission_a'.send(param_method), Group)).to be_falsey
          end

          it 'returns true for an instance' do
            expect(user.has_permission?('user_permission_a'.send(param_method), Forum.first)).to be_truthy
          end
        end

        context 'assigned an instance scoped permission' do
          before(:each) {
            user.add_permission('user_permission_a'.send(param_method), Forum.first)
          }

          it 'returns false for global' do
            expect(user.has_permission?('user_permission_a'.send(param_method))).to be_falsey
          end

          it 'returns false for a class' do
            expect(user.has_permission?('user_permission_a'.send(param_method), Forum)).to be_falsey
          end

          it 'returns true for an instance' do
            expect(user.has_permission?('user_permission_a'.send(param_method), Forum.first)).to be_truthy
          end

          it 'returns false for a different instance' do
            expect(user.has_permission?('user_permission_a'.send(param_method), Group.first)).to be_falsey
          end
        end
      end
    end

    context 'assigned a global role' do

      it 'returns true for a permission in a global role' do
        expect(subject.has_permission?('update_user'.send(param_method))).to be_truthy
      end

      it 'returns true for a permission in a class role' do
        expect(subject.has_permission?('update_user'.send(param_method), Group)).to be_truthy
      end

      it 'returns true for a permission in an instance role' do
        expect(subject.has_permission?('update_user'.send(param_method), Group.first)).to be_truthy
      end

    end

    context 'assigned a class role' do

      it 'returns false for a permission in a global role' do
        expect(subject.has_permission?('view_user'.send(param_method))).to be_falsey
      end

      it 'returns true for a permission in a class role' do
        expect(subject.has_permission?('view_user'.send(param_method), Group)).to be_truthy
      end

      it 'returns false for a permission in a different class role' do
        expect(subject.has_permission?('view_user'.send(param_method), Forum)).to be_falsey
      end

      it 'returns true for a permission in an instance role' do
        expect(subject.has_permission?('view_user'.send(param_method), Group.first)).to be_truthy
      end

      it 'returns false for a permission in an instance role of a different class' do
        expect(subject.has_permission?('view_user'.send(param_method), Forum.first)).to be_falsey
      end

    end

    context 'assigned an instance role' do

      it 'returns false for a permission in a global role' do
        expect(subject.has_permission?('create_user'.send(param_method))).to be_falsey
      end

      it 'returns false for a permission in a class role' do
        expect(subject.has_permission?('create_user'.send(param_method), Forum)).to be_falsey
        expect(subject.has_permission?('create_user'.send(param_method), Group)).to be_falsey
      end

      it 'returns true for a permission in an instance role' do
        expect(subject.has_permission?('create_user'.send(param_method), Forum.first)).to be_truthy
        expect(subject.has_permission?('create_user'.send(param_method), Group.first)).to be_truthy
      end

    end

  end

end
