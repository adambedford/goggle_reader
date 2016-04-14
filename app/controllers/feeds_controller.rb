class FeedsController < ApplicationController
  def index
    @articles = current_user.articles
  end

  def new
    @feed = Feed.new
    @feed.users.push(current_user)
  end

  def create
    @feed = Feed.find_or_initialize_by(url: params[:feed][:url])
    @feed.users.push(current_user)

    respond_to do |format|
      if @feed.save
        format.html { redirect_to root_path, notice: "Feed created" }
        format.js { @feed }
      else
        format.html { render "new" }
        format.js { @feed.errors }
      end
    end
  end

  def show
    @feed = current_user.feeds.find(params[:id])
  end

  def refresh
    @feed = current_user.feeds.find(params[:id])
    @feed.refresh!

    redirect_to @feed
  end

  protected

  def feed_params
    params.require(:feed).permit(:url)
  end
end
