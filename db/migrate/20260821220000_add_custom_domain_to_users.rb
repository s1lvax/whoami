class AddCustomDomainToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :custom_domain, :string
    add_index :users, :custom_domain, unique: true
  end
end
