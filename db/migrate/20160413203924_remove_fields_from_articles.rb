class RemoveFieldsFromArticles < ActiveRecord::Migration
  def change
    remove_column(:articles, :user_id, :integer)
    remove_column(:articles, :bookmarked_at, :datetime)
  end
end
