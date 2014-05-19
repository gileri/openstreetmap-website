class ChangesetComment < ActiveRecord::Base
  belongs_to :changeset, :touch => true
  belongs_to :author, :class_name => "User"

  validates_presence_of :id, :on => :update # is it necessary?
  validates_uniqueness_of :id
  validates_presence_of :changeset_id
  validates_associated :changeset
  validates_presence_of :author_id
  validates_associated :author

  # Return the comment text
  def body
    RichText.new("text", read_attribute(:body))
  end
end
