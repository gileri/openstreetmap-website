require 'test_helper'

class ChangesetCommentTest < ActiveSupport::TestCase
  fixtures :changeset_comments

  def test_changeset_comment_count
    assert_equal 2, ChangesetComment.count
  end

  # validations
  def test_does_not_accept_invalid_author
    comment = changeset_comments(:t1)
    
    comment.author = nil
    assert !comment.valid?

    comment.author_id = 999111
    assert !comment.valid? # it's valid and it shoudln't?
  end

  def test_does_not_accept_invalid_changeset
    comment = changeset_comments(:t1)

    comment.changeset = nil
    assert !comment.valid?

    comment.changeset_id = 999111
    assert !comment.valid? # it's valid and it shoudln't?
  end
end
