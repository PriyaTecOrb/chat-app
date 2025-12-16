class CreateConversationMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :conversation_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :conversation, null: false, foreign_key: true
      t.datetime :last_read_at
      t.integer :unread_count, default: 0
      t.boolean :is_admin, default: false
      t.boolean :notifications_enabled, default: true

      t.timestamps
    end

    add_index :conversation_memberships, [:user_id, :conversation_id], 
              unique: true, name: 'index_memberships_on_user_and_conversation'
  end
end
