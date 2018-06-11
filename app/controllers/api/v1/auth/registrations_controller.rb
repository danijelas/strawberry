module Api
  module V1
    module Auth
      class RegistrationsController < Devise::RegistrationsController
        before_action :configure_permitted_parameters
        respond_to :json
        prepend_before_action :authenticate_scope!, only: [:destroy]
        acts_as_token_authentication_handler_for User, only: [:update, :destroy]

        skip_before_action :verify_authenticity_token, only: :create
        rescue_from ActiveRecord::RecordNotFound, with: :not_found

        def create
          build_resource(user_params)
          resource_saved = resource.save
          if resource_saved
            sign_in resource
            response.headers['X-CSRF-Token'] = form_authenticity_token
            render json: resource
          else
            render json: {errors: resource.errors.full_messages.to_sentence }, status: :expectation_failed
          end
        end

        def update
          successfully_updated = if needs_password?(current_user, params)
            current_user.update_with_password(user_params)
          else
            # remove the virtual current_password attribute
            # update_without_password doesn't know how to ignore it
            params[:user].delete(:current_password)
            current_user.update_without_password(user_params)
          end

          if successfully_updated
            # Sign in the user bypassing validation in case their password changed
            # sign_in user, :bypass => true
            render json: current_user
          else
            render json: {errors: current_user.errors.full_messages.to_sentence }, status: :expectation_failed
          end
        end

        # DELETE /resource
        def destroy
          if current_user.destroy
            Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
            head :ok
          else
            render json: {errors: current_user.errors.full_messages.to_sentence }, status: :expectation_failed
          end
            # set_flash_message! :notice, :destroyed
            # yield resource if block_given?
            # respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
        end

        private

        # check if we need password to update user data
        # ie if password or email was changed
        # extend this as needed
        def needs_password?(user, params)
          (params[:user][:email].present? && user.email != params[:user][:email]) ||
            params[:user][:password].present? ||
            params[:user][:password_confirmation].present?
        end

        protected

          def after_update_path_for(resource)
            edit_user_registration_path
          end

        private

          def user_params
            params.require(:user).permit(:first_name, :last_name, :email,
                                         :password, :password_confirmation, :current_password, :currency)
          end

          def configure_permitted_parameters
            devise_parameter_sanitizer.permit(:sign_up,
              keys: [:first_name, :last_name, :email, :password, :password_confirmation, :currency])

            devise_parameter_sanitizer.permit(:account_update,
              keys: [:first_name, :last_name, :email, :password, :password_confirmation, :currency])
          end

          def not_found
            render json: {error: "Email #{I18n.t('errors.messages.not_found')}" }, status: :not_found
          end

      end
    end
  end
end

