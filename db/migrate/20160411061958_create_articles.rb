class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :external_id
      t.string :title
      t.text :summary
      t.string :url
      t.string :image_url
      t.datetime :bookmarked_at
      t.references :feed, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
