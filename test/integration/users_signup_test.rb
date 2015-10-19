require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    ActionMailer::Base.deliveries.clear
  end
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, user: {
        name: "",
        email: "user@invalid",
        password: "foo",
        password_confirmation: "bar",
      }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end
  
  test "valid signup information with activation" do
    # visit link
    get signup_path
    
    # kiem tra gia tri User.count truoc va sau cua block
    assert_difference "User.count", 1 do
      # send 1 post
      post_via_redirect users_path, user: {
        name: "Nguyen Tien Manh",
        email: "user@valid.com",
        password: "password",
        password_confirmation: "password"
      }
    end
    
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    
    # Try to login before activation.
    log_in_as(user)
    assert_not is_logged_in?
    
    # Invalid activation token
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    
    # Invalid token, wrong email
    get edit_account_activation_path(user.activation_token, email: "wrong")
    assert_not is_logged_in?
    
    # Valid token,email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template "users/show"
    assert is_logged_in?
    
    assert_not flash[:error]
  end
  
  
end
