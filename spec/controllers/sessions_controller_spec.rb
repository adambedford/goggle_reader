require 'rails_helper'

describe SessionsController, type: :controller do
  before do
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
  end

  describe "#destroy" do
    before do
      post(:create, provider: :google)
    end

    def do_request
      delete(:destroy)
    end

    it "should clear the session" do
      expect(session[:user_id]).to_not be_nil
      do_request
      expect(session[:user_id]).to be_nil
    end

    it "should redirect to the root path" do
      do_request
      expect(response).to redirect_to root_path
      expect(controller)
    end
  end
end
