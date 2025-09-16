class AddNewsletterOptionToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :send_to_newsletter, :boolean, default: false
  end
end
