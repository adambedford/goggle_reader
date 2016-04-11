require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before do
    OmniAuth.config.test_mode = true
    request.env["omniauth.auth"] = auth_hash
  end

  let(:auth_hash) { JSON.parse(File.read(Rails.root.join('spec/data_fixtures/omniauth_google.json'))) }

  describe "#create" do
    def do_request(options = {})
      post(:create, options)
    end

    context "when the user is new" do
      before do
        User.delete_all
      end

      it "should create a user" do
        expect {
          do_request(provider: :google)
        }.to change { User.count }.by(1)
      end
    end

    it "should create a session" do
      expect(session[:user_id]).to be_nil
      do_request(provider: :google)
      expect(session[:user_id]).to_not be_nil
    end

    it "should redirect to the root path" do
      do_request(provider: :google)
      expect(response).to redirect_to root_path
    end
  end

end
