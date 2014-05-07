class ChangesetComment < ActiveRecord::Base
  belongs_to :changeset, :foreign_key => :changeset_id, :touch => true
  belongs_to :author, :class_name => "User", :foreign_key => :author_id

  validates_presence_of :id, :on => :update
  validates_uniqueness_of :id
  validates_presence_of :changeset_id
  validates_associated :changeset
  validates_presence_of :visible
  validates_associated :author

  # Return the comment text
  def body
    RichText.new("text", read_attribute(:body))
  end
end
