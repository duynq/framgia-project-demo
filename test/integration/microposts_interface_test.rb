require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@user = users(:one)
  	@other_user = users(:two)
  end

  test "micropost interface" do
  	log_in_as(@user)
  	get root_path
  	assert_select 'div.pagination'
    assert_select 'input[type=file]'

  	# Invalid submission
  	assert_no_difference "Micropost.count" do
      post microposts_path, micropost: { content: "" }
    end
    assert_select 'div#error_explanation'

  	# Valid submission
    content = "This micropost really ties the room together"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference "Micropost.count", 1 do
      post microposts_path, micropost: { content: content, picture: picture }
    end
    assert @user.microposts.first.picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body

  	# Delete post
    assert_select 'a', text: 'delete'
    first_microposts = @user.microposts.pagination(page: 1).first
    assert_difference "Micropost.count" do
      delete microposts_path(first_microposts)
    end

  	# Visit other user can't see link delete
    get @other_user
    assert_select 'a', text: 'delete', count: 0
  end

  test "micropost sidebar count" do
    # User with muliple post
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body

    # User with zero post
    log_in_as(@other_user)
    get root_path
    assert_match "0 micropost", response.body
    @other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "1 micropost", response.body
  end
end
