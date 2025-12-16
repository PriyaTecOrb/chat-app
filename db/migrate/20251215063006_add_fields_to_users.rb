class AddFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :username, :string
    add_index :users, :username, unique: true
    add_column :users, :avatar_url, :string
    add_column :users, :last_seen_at, :datetime
  end
end
