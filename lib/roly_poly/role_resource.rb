module RolyPoly
  module RoleResource
    extend ActiveSupport::Concern

    included do
      class_attribute :adapter

      has_many "#{RolyPoly.user_class_name.underscore}_privileges".to_sym, as: :resource

    end

  end
end
