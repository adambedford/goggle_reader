class SessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    user = find_or_create_from_omniauth
    session[:user_id] = user.id
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  def failure
    redirect_to root_path, alert: "Authentication failure"
  end

  protected

  def omniauth_auth
    request.env["omniauth.auth"]
  end

  def find_or_create_from_omniauth
    User.from_omniauth(omniauth_auth)
  end
end
