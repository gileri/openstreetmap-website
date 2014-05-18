require 'test_helper'

class ChangesetCommentTest < ActiveSupport::TestCase
  fixtures :changeset_comments

  def test_changeset_comment_count
    assert_equal 2, ChangesetComment.count
  end
end
