class CreateConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations do |t|
      t.string :title
      t.integer :conversation_type, null: false, default: 0
      t.datetime :last_message_at

      t.timestamps
    end

    add_index :conversations, :conversation_type
    add_index :conversations, :last_message_at
  end
end
