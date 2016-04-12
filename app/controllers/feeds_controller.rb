class FeedsController < ApplicationController
  before_action :load_feeds, only: [:index, :show]

  def index
    @articles = current_user.articles
  end

  def new
    @feed = current_user.feeds.build
  end

  def create
    @feed = current_user.feeds.build(feed_params)

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

    if @feed.refresh!
      redirect_to @feed
    else
      redirect_to @feed, alert: "Unable to refresh feed"
    end

  end

  protected

  def load_feeds
    @feeds = current_user.feeds
  end

  def feed_params
    params.require(:feed).permit(:url)
  end
end
