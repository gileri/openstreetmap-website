class CreateChangesetComments < ActiveRecord::Migration
  def change
    create_table :changeset_comments do |t|
      t.references :changeset, index: true
      t.boolean :visible
      t.references :author_id, index: true
      t.text :body

      t.timestamps
    end
  end
end
