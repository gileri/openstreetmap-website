require 'test_helper'

class UserChangesetCommentsTest < ActionDispatch::IntegrationTest
  fixtures :users, :changesets, :changeset_comments

  # Test the creation of a changeset comment
  def test_showing_create_changeset_comment
    get_via_redirect '/login'
    # We should now be at the login page
    assert_response :success
    assert_template 'user/login'
    # We can now login
    post  '/login', {'username' => "test@openstreetmap.org", 'password' => "test", :referer => '/diary/new'}
    assert_response :redirect

    get "/changeset/#{changesets(:normal_user_closed_change).id}"
    
    assert_response :success
    assert_template 'browse/changeset'

    # We will make sure that the form exists here, full 
    # assert testing of the full form should be done in the
    # functional tests rather than this integration test
    # There are some things that are specific to the integration
    # that need to be tested, which can't be tested in the functional tests
    assert_select "div#content" do
      assert_select "div#sidebar" do
        assert_select "div#sidebar_content" do
          assert_select "div.browse-section" do
            assert_select "form[action='#']" do
              assert_select "textarea[name=text]"
            end
          end
        end
      end
    end
  end
end
