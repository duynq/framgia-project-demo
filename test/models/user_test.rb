require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end
  
  test "name should not be to long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end
  
  test "email should not be to long" do
    @user.name = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email valid" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email invalid" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
                           
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email duplicate" do
    user_dup = @user.dup
    @user.save
    assert_not user_dup.valid?
  end
  
  test "email valid insensetive uniqueness" do
    user_dup = @user.dup
    @user.email.upcase!
    @user.save
    user_dup.email.downcase!
    assert_not user_dup.valid?
  end
  
  test "password is short" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "password is blank" do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end
  
  test "email should be save as lower-case" do
    mixed_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_email
    @user.save
    assert_equal mixed_email.downcase, @user.reload.email
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "associated entries should be destroyes" do
    @user.save
    @user.entries.create!(content: "Lorem ipsum")
    
    assert_difference "Entry.count", -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    user = users(:one)
    other_user = users(:two)

    assert_not user.following?(other_user)
    user.follow(other_user)
    assert user.following?(other_user)
    assert other_user.followers.include?(user)
    user.unfollow(other_user)
    assert_not user.following?(other_user)
  end

  test "feed should have the right posts" do
    michael = users(:one)
    archer  = users(:two)
    lana    = users(:lana)

    # Posts from followed user
    lana.entries.each do |entry|
      assert michael.feed.include?(entry)
    end

    # Posts from self
    michael.entries.each do |entry|
      assert michael.feed.include?(entry)
    end

    # Posts from unfollowed user
    archer.entries.each do |entry|
      assert_not michael.feed.include?(entry)
    end

  end

end
