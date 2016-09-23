shared_examples_for :finders do |param_name, param_method|

  context "using #{param_name} as parameter" do

    describe '.with_role' do
      it { should respond_to(:with_role).with(1).arguments }
      it { should respond_to(:with_role).with(2).arguments }

      context 'with a global role' do

        it { subject.with_role('admin'.send(param_method)).should eq([ admin ]) }
        it { subject.with_role('moderator'.send(param_method)).should be_empty }
        it { subject.with_role('manager'.send(param_method)).should be_empty }

      end

      context 'with a class role' do

        context 'on Forum class' do
          it { subject.with_role('admin'.send(param_method), Forum).should eq([ admin ])}
          it { subject.with_role('moderator'.send(param_method), Forum).should include(admin, moderator)}
          it { subject.with_role('manager'.send(param_method), Forum).should be_empty }
        end

        context 'on Group class' do
          it { subject.with_role('admin'.send(param_method), Group).should eq([ admin ])}
          it { subject.with_role('moderator'.send(param_method), Group).should eq([ admin ])}
          it { subject.with_role('manager'.send(param_method), Group).should eq([ moderator ]) }
        end

      end

      context 'with an instance role' do

        context 'on Forum first instance' do
          it { subject.with_role('admin'.send(param_method), Forum.first).should eq([ admin ])}
          it { subject.with_role('moderator'.send(param_method), Forum.first).should include(admin, manager, moderator)}
          it { subject.with_role('manager'.send(param_method), Forum.first).should eq([ admin ]) }
        end

        context 'on Forum last instance' do
          it { subject.with_role('admin'.send(param_method), Forum.last).should eq([ admin ])}
          it { subject.with_role('moderator'.send(param_method), Forum.last).should include(admin, moderator)}
          it { subject.with_role('manager'.send(param_method), Forum.last).should be_empty }
        end

        context 'on Group first instnace' do
          it { subject.with_role('admin'.send(param_method), Group.first).should eq([ admin ]) }
          it { subject.with_role('moderator'.send(param_method), Group.first).should eq([ admin ]) }
          it { subject.with_role('manager'.send(param_method), Group.first).should eq([ moderator ]) }
        end

      end

    end


    describe '.with_all_roles' do
    end

    describe '.with_any_role' do
    end

  end

end
