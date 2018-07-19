module Api
  module V1
    class UsersController < Api::V1::AuthController
      
      def profile
        response.headers['X-CSRF-Token'] = form_authenticity_token
        render json: current_user
      end

      # izgleda da ne treba ovo
      # def update
        # emailFromHeader = request.headers["X-User-Email"]
        # user = User.find_by(email: emailFromHeader)
        # user.update(user_params)
        # response.headers['X-CSRF-Token'] = form_authenticity_token
        # render json: user
      # end
    end
  end
end
