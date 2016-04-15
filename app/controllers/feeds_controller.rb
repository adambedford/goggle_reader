class FeedsController < ApplicationController
  before_action :find_feed, only: [:show, :refresh, :unsubscribe]

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
  end

  def refresh
    @feed.refresh!

    redirect_to @feed
  end

  def unsubscribe
    @feed.unsubscribe_user(current_user)
    redirect_to :back, notice: "Unsubscribed from #{@feed.name}"
  end

  protected

  def feed_params
    params.require(:feed).permit(:url)
  end

  def find_feed
    @feed = current_user.feeds.find(params[:id])
  end
end
