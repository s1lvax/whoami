class AddNewsletterSentToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :newsletter_sent, :boolean, default: false, null: false
  end
end
