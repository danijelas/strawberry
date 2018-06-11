module Api
  module V1
    module Auth
      class PasswordsController < Devise::PasswordsController
        respond_to :json

        rescue_from ActiveRecord::RecordNotFound, with: :not_found

        def create
          user = User.find_by!(email: params[:email])
          if user.present?
            user.send_reset_password_instructions
            render json: {message: I18n.t('devise.passwords.send_instructions') }
          end

        end

        private

          def not_found
            render json: {error: "Email #{I18n.t('errors.messages.not_found')}" }, status: :not_found
          end

      end
    end
  end
end

