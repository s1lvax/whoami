class AddOnboardingFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :onboarded, :boolean
    add_column :users, :onboarded_at, :datetime
    add_column :users, :username, :string


    add_index :users, :username, unique: true
  end
end
