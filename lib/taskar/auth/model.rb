module Taskar
  module Auth
    module Model
      def self.included(model)
        model.send(:before_save, :downcase_email)
        model.send(:devise, :database_authenticatable, :lockable, :recoverable, :rememberable, :trackable, :validatable, :registerable)
        model.extend(ClassMethods)
      end

      module ClassMethods
        def find_for_authentication(conditions)
          conditions[:email].downcase! if conditions[:email]
          super(conditions)
        end
      end

      def downcase_email
        self.email = email.to_s.downcase
      end
    end
  end
end