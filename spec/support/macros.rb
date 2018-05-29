module Strawberry

  module ControllerMacros
    def login_user(user = FactoryBot.create(:user))
      sign_out @user unless @user.nil?
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = user
      # @user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      sign_in @user
    end
  end

  module RequestMacros
    include Warden::Test::Helpers

    def self.included(base)
      base.before(:each) { Warden.test_mode! }
      base.after(:each) { Warden.test_reset! }
    end

    # for use in request specs
    def sign_in_user(user = FactoryBot.create(:user))
      sign_out @user unless @user.nil?
      @user = user
      login_as(@user, scope: :user)
    end

    def json
      JSON.parse(response.body)
    end
  end

  # module MailerMacros
  #   def delayed_mail_jobs_size
  #     Sidekiq::Extensions::DelayedMailer.jobs.size
  #   end
  # end
end

RSpec.configure do |config|
  config.include Strawberry::ControllerMacros, type: :controller
  config.include Strawberry::RequestMacros, type: :request
  # config.include Basara::MailerMacros, type: :controller
  # config.include Basara::MailerMacros, type: :request
end
