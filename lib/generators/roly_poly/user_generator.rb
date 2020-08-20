module RolyPoly
  module Generators

    class UserGenerator < Rails::Generators::Base

      desc 'Modifies the existing User model to include methods required for RolyPoly'

      argument :user_class, type: :string, default: 'User'

      # Adds the `roled_up` class method call to
      # the existing user model
      def configure_user_class
        inject_into_file(model_path, after: user_class_definition) do
          "  has_roles\n"
        end
      end

      def user_class_definition
        /class #{class_name.camelize}\n|class #{class_name.camelize} .*\n|class #{class_name.demodulize.camelize}\n|class #{class_name.demodulize.camelize} .*\n/
      end

      def model_path
        File.join('app', 'models', "#{user_class.underscore.downcase}.rb")
      end

      def class_name
        user_class.underscore.downcase
      end

    end

  end
end
