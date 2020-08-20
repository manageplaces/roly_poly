shared_examples_for '#remove_role_examples' do |param_type, param_method|

  context "using #{param_type} as parameter", scope: :unrestricted do

    context 'removing a global role' do

      context 'when a global role of the user' do
        it 'removes the role' do
          expect { subject.remove_role('superhero'.send(param_method)) }.to change { subject.roles.count }.by(-1)
          expect(subject).not_to have_role('superhero'.send(param_method))
        end

      end

      context 'when a class role of the user' do
        it 'removes the role' do
          expect { subject.remove_role('god'.send(param_method)) }.to change { subject.roles.count }.by(-1)
          expect(subject).not_to have_role('god'.send(param_method), Group)
        end
      end

      context 'when an instance role of the user' do
        it 'removes the role' do
          expect { subject.remove_role('moderator'.send(param_method)) }.to change { subject.roles.count }.by(-2)
          expect(subject).not_to have_role('moderator'.send(param_method), Forum.first)
          expect(subject).not_to have_role('moderator'.send(param_method), Group.first)
        end
      end

      context 'when the user does not have the role' do
        it { expect { subject.remove_role('no_role'.send(param_method)) }.not_to change { subject.roles.count } }
      end

    end

    context 'removing a class scoped role' do

      context 'when a gobal role of the user' do
        it { expect { subject.remove_role('god'.send(param_method), Forum) }.not_to change { subject.roles.count } }
      end

      context 'when a class role of the user' do
        it 'remove the role' do
          expect { subject.remove_role('god'.send(param_method), Group) }.to change { subject.roles.count }.by(-1)
          expect(subject).not_to have_role('god'.send(param_method), Group.first)
        end
      end

      context 'when an instance role of the user' do
        it 'removes the role' do
          expect { subject.remove_role('moderator'.send(param_method), Group) }.to change { subject.roles.count }.by(-1)
          expect(subject).not_to have_role('moderator'.send(param_method), Group.first)
          expect(subject).to have_role('moderator'.send(param_method), Forum.first)
        end
      end

      context 'when the user does not have the role' do
        it { expect { subject.remove_role('no_role'.send(param_method), Group) }.not_to change { subject.roles.count } }
      end

    end

    context 'removing an instance scoped role' do

      context 'when a global role of the user' do
        it { expect { subject.remove_role('god'.send(param_method), Group.first) }.not_to change { subject.roles.count } }
      end

      context 'when a class role of the user' do
        it { expect { subject.remove_role('manager'.send(param_method), Group.last) }.not_to change { subject.roles.count } }
      end

      context 'when an instance role of the user' do
        it 'removes the role' do
          expect { subject.remove_role('moderator'.send(param_method), Group.first) }.to change { subject.roles.count }.by(-1)
          expect(subject).not_to have_role('moderator'.send(param_method), Group.first)
        end
      end

      context 'when the user does not have the role' do
        it { expect { subject.remove_role('no_role'.send(param_method), Group.first) }.not_to change { subject.roles.count } }
      end

    end

  end

end
