module Api
  module V1
    class AuthController < ActionController::Base
      acts_as_token_authentication_handler_for User, fallback: :exception
      respond_to :json
      protect_from_forgery with: :null_session, prepend: true
    end
  end
end
