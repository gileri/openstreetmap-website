require 'migrate'

class AddJoinTableBetweenUsersAndChangesetsForThanks < ActiveRecord::Migration
  def change
    create_table :changesets_thankers, id: false do |t|
      t.column :thanker_id, :bigint, null: false
      t.column :changeset_id, :bigint, null: false
    end
    add_foreign_key :changesets_thankers, [:thanker_id], :users, [:id]
    add_foreign_key :changesets_thankers, [:changeset_id], :changesets, [:id]
    add_index :changesets_thankers, [:thanker_id, :changeset_id], { :unique => true }
    add_index :changesets_thankers, [:changeset_id]
  end
end
