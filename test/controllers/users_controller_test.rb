require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'not actually a test' do
    assert_not false
  end

  test '#signup_success' do
    post :signup, {'username' => 'testuser', 'password' => 'testpass'}
    json = JSON.parse(response.body)
    assert json['user_name'] == 'testuser'
    assert json['login_count'] == 1
  end

  test '3signup_failure_user' do
    post :signup, {'username' => 'test', 'password' => 'testpass'}
    json = JSON.parse(response.body)
    assert json['error_code'] == -1
  end

  test '3signup_failure_pwd' do
    post :signup, {'username' => 'testuser', 'password' => 'test'}
    json = JSON.parse(response.body)
    assert json['error_code'] == -2
  end

end
