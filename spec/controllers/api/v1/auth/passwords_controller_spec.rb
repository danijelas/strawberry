require 'rails_helper'

describe Api::V1::Auth::PasswordsController, type: :request do

  let(:headers) { {'Content-Type': 'application/json', 'Accept': 'application/json' } }
  let(:user) { create(:user) }
  let(:email) { user.email }

  context "Send Instructions - POST #forgot as :json" do

    let(:endpoint) { api_v1_auth_forgot_path }
    let(:right_request) { { email: email } }
    let(:wrong_request) { { email: 'wrong@wrong.com' } }

    it "should successfully find user and send email" do
      post endpoint, params: JSON.dump(right_request), headers: headers

      # TODO use this for mail test when we switch to active job
      # expect(delayed_mail_jobs_size).to eq 1
      expect(ActionMailer::Base.deliveries.size).to eq 1

      expect(response).to be_successful
      expect_json('message', I18n.t('devise.passwords.send_instructions'))
    end

    it "should return error message" do
      post endpoint, params: JSON.dump(wrong_request), headers: headers

      expect(response).to have_http_status(404)
      expect_json('error', "Email #{I18n.t('errors.messages.not_found')}")
    end

  end

end
