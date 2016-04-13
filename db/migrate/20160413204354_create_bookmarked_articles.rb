class CreateBookmarkedArticles < ActiveRecord::Migration
  def change
    create_table :bookmarked_articles do |t|
      t.references :article, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
