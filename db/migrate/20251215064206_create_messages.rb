class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :parent_message, foreign_key: { to_table: :messages }
      t.text :content
      t.integer :message_type, default: 0
      t.json :metadata
      t.datetime :edited_at
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :messages, :created_at
    add_index :messages, :deleted_at
  end
end
