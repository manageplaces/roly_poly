shared_examples_for '#has_role?_examples' do |param_type, param_method|

  context "using #{param_type} as parameter", scope: :unrestricted do

    context 'without a role' do

      it 'returns false when role does not exist' do
        expect(subject.has_role?('invalid_role'.send(param_method))).to be_falsey
        expect(subject.has_role?('invalid_role'.send(param_method), Forum)).to be_falsey
        expect(subject.has_role?('invalid_role'.send(param_method), Forum.first)).to be_falsey
      end

      it 'returns false if not assigned the role' do
        expect(subject.has_role?('teammember'.send(param_method))).to be_falsey
        expect(subject.has_role?('teammember'.send(param_method), Forum)).to be_falsey
        expect(subject.has_role?('teammember'.send(param_method), Forum.first)).to be_falsey
      end

    end


    context 'assigned a global role' do

      it 'returns true for global role' do
        expect(subject.has_role?('superhero'.send(param_method))).to be_truthy
      end

      it 'returns true for class role' do
        expect(subject.has_role?('superhero'.send(param_method), Group)).to be_truthy
      end

      it 'returns true for instance role' do
        expect(subject.has_role?('superhero'.send(param_method), Group.first)).to be_truthy
      end

    end

    context 'assigned a class role' do

      it 'returns false for global roles' do
        expect(subject.has_role?('god'.send(param_method))).to be_falsey
      end

      it 'returns true for class role' do
        expect(subject.has_role?('god'.send(param_method), Group)).to be_truthy
      end

      it 'return true for instance roles' do
        expect(subject.has_role?('god'.send(param_method), Group.first)).to be_truthy
      end

    end

    context 'assigned an instance role' do

      it 'returns false for global roles' do
        expect(subject.has_role?('moderator'.send(param_method))).to be_falsey
      end

      it 'returns false for class roles' do
        expect(subject.has_role?('moderator'.send(param_method), Group)).to be_falsey
      end

      it 'returns true for instance roles' do
        expect(subject.has_role?('moderator'.send(param_method), Group.first)).to be_truthy
      end

    end

    context 'company scoped roles' do

      context 'without scoping the role' do
        context 'global scoped' do
          it 'returns false for global role' do
            expect(subject.has_role?('company_superhero'.send(param_method))).to be_falsey
          end

          it 'returns false for class role' do
            expect(subject.has_role?('company_superhero'.send(param_method), Group)).to be_falsey
          end

          it 'returns false for instance role' do
            expect(subject.has_role?('company_superhero'.send(param_method), Group.first)).to be_falsey
          end
        end

        context 'class scoped' do
          it 'returns false for global roles' do
            expect(subject.has_role?('company_god'.send(param_method))).to be_falsey
          end

          it 'returns false for class role' do
            expect(subject.has_role?('company_god'.send(param_method), Group)).to be_falsey
          end

          it 'return false for instance roles' do
            expect(subject.has_role?('company_god'.send(param_method), Group.first)).to be_falsey
          end
        end

        context 'instance scoped' do
          it 'returns false for global roles' do
            expect(subject.has_role?('company_moderator'.send(param_method))).to be_falsey
          end

          it 'returns false for class roles' do
            expect(subject.has_role?('company_moderator'.send(param_method), Group)).to be_falsey
          end

          it 'returns false for instance roles' do
            expect(subject.has_role?('company_moderator'.send(param_method), Group.first)).to be_falsey
          end
        end
      end

      context 'scoping the role to the company' do

        context 'global scoped' do
          it 'returns true for global role' do
            expect(subject.has_role?({ name: 'company_superhero'.send(param_method), resource: company })).to be_truthy
            expect(subject.has_role?(role_class.where(name: 'company_superhero', resource_id: company.id, resource_type: 'Company').first)).to be_truthy
          end

          it 'returns true for class role' do
            expect(subject.has_role?({ name: 'company_superhero'.send(param_method), resource: company }, Group)).to be_truthy
            expect(subject.has_role?(role_class.where(name: 'company_superhero', resource_id: company.id, resource_type: 'Company').first, Group)).to be_truthy
          end

          it 'returns true for instance role' do
            expect(subject.has_role?({ name: 'company_superhero'.send(param_method), resource: company }, Group.first)).to be_truthy
            expect(subject.has_role?(role_class.where(name: 'company_superhero', resource_id: company.id, resource_type: 'Company').first, Group.first)).to be_truthy
          end
        end

        context 'class scoped' do
          it 'returns false for global roles' do
            expect(subject.has_role?({ name: 'company_god'.send(param_method), resource: company })).to be_falsey
            expect(subject.has_role?(role_class.where(name: 'company_god', resource_id: company.id, resource_type: 'Company').first)).to be_falsey
          end

          it 'returns true for class role' do
            expect(subject.has_role?({ name: 'company_god'.send(param_method), resource: company }, Group)).to be_truthy
            expect(subject.has_role?(role_class.where(name: 'company_god', resource_id: company.id, resource_type: 'Company').first, Group)).to be_truthy
          end

          it 'return true for instance roles' do
            expect(subject.has_role?({ name: 'company_god'.send(param_method), resource: company }, Group.first)).to be_truthy
            expect(subject.has_role?(role_class.where(name: 'company_god', resource_id: company.id, resource_type: 'Company').first, Group.first)).to be_truthy
          end
        end

        context 'instance scoped' do
          it 'returns false for global roles' do
            expect(subject.has_role?({ name: 'company_moderator'.send(param_method), resource: company })).to be_falsey
            expect(subject.has_role?(role_class.where(name: 'company_moderator', resource_id: company.id, resource_type: 'Company').first)).to be_falsey
          end

          it 'returns false for class role' do
            expect(subject.has_role?({ name: 'company_moderator'.send(param_method), resource: company }, Group)).to be_falsey
            expect(subject.has_role?(role_class.where(name: 'company_moderator', resource_id: company.id, resource_type: 'Company').first, Group)).to be_falsey
          end

          it 'return true for instance roles' do
            expect(subject.has_role?({ name: 'company_moderator'.send(param_method), resource: company }, Group.first)).to be_truthy
            expect(subject.has_role?(role_class.where(name: 'company_moderator', resource_id: company.id, resource_type: 'Company').first, Group.first)).to be_truthy
          end
        end

      end

    end

  end

end
