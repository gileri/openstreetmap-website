require 'migrate'

class AddJoinTableBetweenUsersAndChangesetsForLikes < ActiveRecord::Migration
  def change
    create_table :changesets_likers, id: false do |t|
      t.column :liker_id, :bigint, null: false
      t.column :changeset_id, :bigint, null: false
    end
    add_foreign_key :changesets_likers, [:liker_id], :users, [:id]
    add_foreign_key :changesets_likers, [:changeset_id], :changesets, [:id]
  end
end
