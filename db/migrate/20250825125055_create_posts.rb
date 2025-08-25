class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string  :title,  null: false
      t.text    :excerpt
      t.integer :views,  null: false, default: 0
      t.string  :status, null: false, default: "draft" # draft|published
      t.string  :slug
      t.datetime :published_at
      t.timestamps
    end

    add_index :posts, [ :user_id, :status, :published_at ]
    add_index :posts, :slug, unique: true
  end
end
