class HomeController < ApplicationController
  def index
    if current_user
      redirect_to feeds_path
    else
      render "application/_signed_out_index"
    end
  end
end
