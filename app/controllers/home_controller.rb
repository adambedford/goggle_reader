class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if current_user
      redirect_to articles_path
    else
      render "application/_signed_out_index"
    end
  end
end
