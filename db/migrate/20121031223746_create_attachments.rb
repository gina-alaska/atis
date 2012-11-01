class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :name
      t.string :file_uid
      t.integer :parent_id
      t.string :parent_type

      t.timestamps
    end
  end
end
