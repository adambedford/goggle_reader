class FeedsController < ApplicationController
  def index
    @feeds = Feed.all
  end

  def new
    @feed = Feed.new
  end

  def create
    @feed = Feed.new(feed_params)

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
    @feed = Feed.find(params[:id])
    @articles = Feedjira::Feed.fetch_and_parse(@feed.url).entries
  end

  protected

  def feed_params
    params.require(:feed).permit(:url)
  end
end
