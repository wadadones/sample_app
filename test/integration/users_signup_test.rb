require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end
  test "invalid signup information" do
  	get signup_path
  	assert_no_difference 'User.count' do
  		post users_path, params: { user: { name: "",
  																			email: "user@invalid",
  																			password: "foo",
  																			password_confirmation: "bar" } }
  																			
  	end
  	assert_template 'users/new' #users/newが表示されてるかテスト
  	assert_select 'div#error_explanation'
  	assert_select 'div.alert'
  end



  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                                        email: "user@example.com",
                                        password: "password",
                                        password_confirmation: "password"} }

    end
    assert_equal 1, ActionMailer::Base.deliveries.size  # 配信メッセージは一つか？
    user = assigns(:user)
    assert_not user.activated?
    #有効かしていない場合でのログイン
    log_in_as(user)
    assert_not is_logged_in?
    #有効化トークンが不正の場合
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    #トークン正しいがめーるあどれすが無効な場合
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    #有効化トークンが正しい場合
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end

end
