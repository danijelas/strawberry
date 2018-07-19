require 'rails_helper'

describe Api::V1::UsersController, type: :request do

  let(:headers) { {'Content-Type': 'application/json', 'Accept': 'application/json' } }
  let(:user) { create(:user, authentication_token: 'token') }

  context "GET #profile as :json" do

    let(:endpoint) { api_v1_profile_path }
    let(:right_auth_headers) { { 'X-User-Email': user.email, 'X-User-Token': user.authentication_token } }
    let(:wrong_auth_headers) { { 'X-User-Email': user.email, 'X-User-Token': 'wrong_token' } }

    it "should return 200 and user info" do
      get endpoint, params: nil, headers: headers.merge(right_auth_headers)

      expect(response).to be_successful

      expect_json_keys([:email, :authentication_token, :first_name, :last_name, :currency])
      expect_json(authentication_token: user.authentication_token)
    end

    it "should return 401 and error message" do
      get endpoint, params: nil, headers: headers.merge(wrong_auth_headers)

      expect(response).to have_http_status(401)

      expect_json('error', I18n.t('devise.failure.unauthenticated'))
    end

  end
end