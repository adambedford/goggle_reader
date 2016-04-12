class AddLastRefreshAtToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :last_refresh_at, :datetime
  end
end
