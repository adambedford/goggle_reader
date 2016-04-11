require 'rails_helper'

describe "GET /auth/google/callback" do
  before do
    OmniAuth.config.mock_auth[:google] = omniauth_google_hash
  end

  def do_request(options = {})
    post("/auth/google/callback", options)
  end

  it "should redirect to the root path" do
    do_request
    expect(response).to redirect_to root_path
  end
end

describe "DELETE /logout" do
  def do_request
    delete("/logout")
  end

  it "should redirect to the root path with a notice" do
    do_request
    expect(response).to redirect_to root_path
  end
end

describe "GET /auth/failure" do
  before do
    OmniAuth.config.mock_auth[:google] = :invalid_credentials
  end

  def do_request(options = {})
    post("/auth/failure", options)
  end

  it "redirects to the root path with a notice" do
    expect(do_request).to redirect_to root_path
  end
end
