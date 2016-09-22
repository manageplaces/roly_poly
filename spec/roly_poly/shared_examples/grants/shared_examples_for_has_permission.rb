shared_examples_for '#has_permission?_examples' do |param_type, param_method|

  context "using #{param_type} as parameter", scope: :unrestricted do

    context 'without a permission' do

      it 'returns false if the permission does not exist' do
        expect(subject.has_permission?(:invalid_permission)).to be_falsey
        expect(subject.has_permission?(:invalid_permission, Forum)).to be_falsey
        expect(subject.has_permission?(:invalid_permission, Forum.first)).to be_falsey
      end

    end

    context 'without a role' do
      let(:user) { User.new(name: 'no role user') }

      it 'returns false' do
        expect(user.has_permission?(:create_user)).to be_falsey
        expect(user.has_permission?(:create_user, Forum)).to be_falsey
        expect(user.has_permission?(:create_user, Forum.first)).to be_falsey
      end
    end

    context 'assigned a global role' do

      it 'returns true for a permission in a global role' do
        expect(subject.has_permission?(:update_user)).to be_truthy
      end

      it 'returns true for a permission in a class role' do
        expect(subject.has_permission?(:update_user, Group)).to be_truthy
      end

      it 'returns true for a permission in an instance role' do
        expect(subject.has_permission?(:update_user, Group.first)).to be_truthy
      end

    end

    context 'assigned a class role' do

      it 'returns false for a permission in a global role' do
        expect(subject.has_permission?(:view_user)).to be_falsey
      end

      it 'returns true for a permission in a class role' do
        expect(subject.has_permission?(:view_user, Group)).to be_truthy
      end

      it 'returns false for a permission in a different class role' do
        expect(subject.has_permission?(:view_user, Forum)).to be_falsey
      end

      it 'returns true for a permission in an instance role' do
        expect(subject.has_permission?(:view_user, Group.first)).to be_truthy
      end

      it 'returns false for a permission in an instance role of a different class' do
        expect(subject.has_permission?(:view_user, Forum.first)).to be_falsey
      end

    end

    context 'assigned an instance role' do

      it 'returns false for a permission in a global role' do
        expect(subject.has_permission?(:create_user)).to be_falsey
      end

      it 'returns false for a permission in a class role' do
        expect(subject.has_permission?(:create_user, Forum)).to be_falsey
        expect(subject.has_permission?(:create_user, Group)).to be_falsey
      end

      it 'returns true for a permission in an instance role' do
        expect(subject.has_permission?(:create_user, Forum.first)).to be_truthy
        expect(subject.has_permission?(:create_user, Group.first)).to be_truthy
      end

    end

  end

end
