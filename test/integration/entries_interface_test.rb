require 'test_helper'

class EntriesInterfaceTest < ActionDispatch::IntegrationTest

  def setup
  	@user = users(:one)
  	@other_user = users(:two)
  end

  test "entry interface" do
  	log_in_as(@user)
  	get root_path
  	assert_select 'div.pagination'
    assert_select 'input[type=file]'

  	# Invalid submission
  	assert_no_difference "Entry.count" do
      post entries_path, entry: { content: "" }
    end
    assert_select 'div#error_explanation'

  	# Valid submission
    content = "This entry really ties the room together"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference "Entry.count", 1 do
      post entries_path, entry: { content: content, picture: picture }
    end
    assert @user.entries.first.picture?
    assert_redirected_to root_url
    assert_match content, request.body

  	# Delete post
    assert_select a, text: 'delete'
    first_entries = @user.entries.pagination(page: 1).first
    assert_difference "Entry.count" do
      delete entries_path(first_entries)
    end

  	# Visit other user can't see link delete
    get @other_user
    assert_select 'a', text: 'delete', count: 0
  end

  test "entry sidebar count" do
    # User with muliple post
    log_in_as(@user)
    get root_path
    assert_match "#{@user.entries.count} entries", response.body

    # User with zero post
    log_in_as(@other_user)
    get root_path
    assert_match "0 entry", response.body
    @other_user.entries.create!(content: "A entry")
    get root_path
    assert_match "1 entry", response.body
  end
end
