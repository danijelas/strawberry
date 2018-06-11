require 'rails_helper'

describe Api::V1::Auth::SessionsController, type: :request do

  let(:headers) { {'Content-Type': 'application/json', 'Accept': 'application/json' } }
  let(:user) { create(:user) }
  let(:email) { user.email }
  let(:password) { user.password }

  context "Login - POST #create as :json" do

    let(:endpoint) { api_v1_auth_login_path }
    let(:right_request) { { user: { email: email, password: password } } }
    let(:wrong_request) { { user: { email: email, password: 'wrong_password' } } }

    it "should successfully return access token and user info" do
      post endpoint, params: JSON.dump(right_request), headers: headers

      expect(response).to be_successful
      expect(response.headers).to include "X-CSRF-Token"

      expect_json_keys([:email, :authentication_token, :first_name, :last_name, :currency])
      expect_json(authentication_token: user.authentication_token)
    end

    it "should return error message" do
      post endpoint, params: JSON.dump(wrong_request), headers: headers

      expect(response).to have_http_status(401)

      # expect_json_keys('error', I18n.t('devise.failure.invalid', authentication_keys: ['Email'].join(I18n.translate(:"support.array.words_connector"))))
      expect_json_types(error: :string)
    end

  end

  context "Logout - DELETE #destory as :json" do
    let(:endpoint) { api_v1_auth_logout_path }
    it 'should logout user' do
      sign_in(user)
      old_token = user.authentication_token
      delete endpoint, headers: headers
      expect(user.authentication_token).not_to eq old_token
      expect(response).to be_successful
    end
  end

end
