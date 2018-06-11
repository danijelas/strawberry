module Api
  module V1
    module Auth
      class SessionsController < Devise::SessionsController
        respond_to :json

        # skip_before_action :verify_authenticity_token, only: :destroy
        # skip_before_action :verify_authenticity_token

        def create
          # sign_out if current_user
          self.resource = warden.authenticate!(auth_options)
          sign_in(resource_name, resource)
          response.headers['X-CSRF-Token'] = form_authenticity_token
          render json: resource
        end

        def destroy
          if current_user
            current_user.update_attribute(:authentication_token, nil)
            signed_out = Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
            response.headers['X-CSRF-Token'] = form_authenticity_token
            head :ok
          end
        end

      end
    end
  end
end

