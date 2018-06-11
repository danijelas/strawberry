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

  # module RequestMacros
  #   def json
  #     JSON.parse(response.body)
  #   end
  # end

  # module MailerMacros
  #   def delayed_mail_jobs_size
  #     Sidekiq::Extensions::DelayedMailer.jobs.size
  #   end
  # end
end

RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Strawberry::ControllerMacros, type: :controller
  # config.include Strawberry::RequestMacros, type: :request
  # config.include Basara::MailerMacros, type: :controller
  # config.include Basara::MailerMacros, type: :request
end
