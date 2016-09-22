shared_examples_for '#has_role?_examples' do |param_type, param_method|

  context "using #{param_type} as parameter", scope: :unrestricted do

    context 'without a role' do

      it 'returns false when role does not exist' do
        expect(subject.has_role?(:invalid_role)).to be_falsey
        expect(subject.has_role?(:invalid_role, Forum)).to be_falsey
        expect(subject.has_role?(:invalid_role, Forum.first)).to be_falsey
      end

      it 'returns false if not assigned the role' do
        expect(subject.has_role?(:teammember)).to be_falsey
        expect(subject.has_role?(:teammember, Forum)).to be_falsey
        expect(subject.has_role?(:teammember, Forum.first)).to be_falsey
      end

    end


    context 'assigned a global role' do

      it 'returns true for global role' do
        expect(subject.has_role?(:superhero)).to be_truthy
      end

      it 'returns true for class role' do
        expect(subject.has_role?(:superhero, Group)).to be_truthy
      end

      it 'returns true for instance role' do
        expect(subject.has_role?(:superhero, Group.first)).to be_truthy
      end

    end

    context 'assigned a class role' do

      it 'returns false for global roles' do
        expect(subject.has_role?(:god)).to be_falsey
      end

      it 'returns true for class role' do
        expect(subject.has_role?(:god, Group)).to be_truthy
      end

      it 'return true for instance roles' do
        expect(subject.has_role?(:god, Group.first)).to be_truthy
      end

    end

    context 'assigned an instance role' do

      it 'returns false for global roles' do
        expect(subject.has_role?(:moderator)).to be_falsey
      end

      it 'returns false for class roles' do
        expect(subject.has_role?(:moderator, Group)).to be_falsey
      end

      it 'returns true for instance roles' do
        expect(subject.has_role?(:moderator, Group.first)).to be_truthy
      end

    end

  end

end
