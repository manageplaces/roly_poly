require 'rspec/expectations'

Rspec::Matchers.define :have_role do |*args|
  match do |resource|
    resource.has_role?(*args)
  end

  failure_message do |resource|
    "expected to have role #{args.map(&:inspect).join(' ')}"
  end

  failure_message_when_negated do |resource|
    "expected not to have role #{args.map(&:inspect).join(' ')}"
  end
end

Rspec::Matchers.define :have_permission do |*args|

end
