require 'rails_helper'

describe Api::V1::Auth::RegistrationsController, type: :request do

  let(:headers) { {'Content-Type': 'application/json', 'Accept': 'application/json' } }

  let(:common) { {
    email: 'test@test.com',
    password: 'password',
    password_confirmation: 'password',
    first_name: 'John',
    last_name: 'Doe',
    currency: 'EUR'
  } }

  context "Register - POST #create as :json" do

    let(:endpoint) { api_v1_auth_register_path }

    let(:right_request) { { user: common } }

    let(:wrong_request) { { user: common.delete_if{|k,| k == :email} } }

    it "should successfully return access token and user info for user" do
      post endpoint, params: JSON.dump(right_request), headers: headers

      expect(response).to be_successful

      expect_json_keys([:email, :authentication_token, :first_name, :last_name, :currency])
    end

    it "should return error message" do
      post endpoint, params: JSON.dump(wrong_request), headers: headers

      expect(response).to have_http_status(417)

      expect_json_types(errors: :string)
    end

  end

  context "Update Account - PUT #update as :json" do
    let(:endpoint) { api_v1_auth_update_profile_path }
    let(:user) { create(:user, currency: 'USD') }
    let(:email) { user.email }
    let(:wrong_request) { { user: { email: 'wrong@wrong.com' } } }
    before :each do
      sign_in(user)
    end

    context 'Profile update' do
      let(:no_email_password) { common.reject{|k,v| k.in?([:email, :password, :password_confirmation])} }
      let(:clean_request) { { user: no_email_password.merge({ email: user.email }) } }
      
      it 'should change users info' do
        expect(user.first_name).not_to eq 'John'
        expect(user.last_name).not_to eq 'Doe'
        expect(user.currency).not_to eq 'EUR'

        put endpoint, params: JSON.dump(clean_request), headers: headers

        expect(response).to be_successful

        user.reload
        expect(user.first_name).to eq 'John'
        expect(user.last_name).to eq 'Doe'
        expect(user.currency).to eq 'EUR'

        expect_json_keys([:email, :authentication_token, :first_name, :last_name, :currency])
      end

    end


    it "should return error message" do
      put endpoint, params: JSON.dump(wrong_request), headers: headers

      expect(response).to have_http_status(417)
      expect_json('errors', "Current password #{I18n.t('errors.messages.blank')}")
    end
  end

  context "Delete Account - DELETE #destroy as :json" do
    let(:endpoint) { api_v1_auth_delete_account_path }
    let(:user) { create(:user) }

    it 'should delete user' do
      sign_in(user)
      delete endpoint, headers: headers

      expect(response).to be_successful
      expect(User.where(email: user.email).count).to eq 0
      # expect(User.where(email: User::GDPR_EMAIL).count).to eq 1

    end

    it "should return error message" do
      delete endpoint, headers: headers
      
      expect(response).to have_http_status(401)
      expect_json_types(error: :string)
    end
  end

end
