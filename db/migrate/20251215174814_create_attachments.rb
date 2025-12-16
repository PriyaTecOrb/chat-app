class CreateAttachments < ActiveRecord::Migration[8.0]
  def change
    create_table :attachments do |t|
      t.references :attachable, polymorphic: true, null: false
      t.string :file_name
      t.string :file_type
      t.bigint :file_size
      t.string :url
      t.json :metadata

      t.timestamps
    end
    
    add_index :attachments, [:attachable_id, :attachable_type]
    add_index :attachments, :file_type
  end
end
