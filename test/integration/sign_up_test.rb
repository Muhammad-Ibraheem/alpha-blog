# frozen_string_literal: true

require 'test_helper'

class SignUpTest < ActionDispatch::IntegrationTest
  test 'it should signup user' do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { username: 'test', email: 'test@example.com', password: 'password' } }
      follow_redirect!
    end
    assert_match 'test', response.body
  end

  test 'invalid username and email results in failure' do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: ' ', email: 'test@example.com', password: 'password' } }
    end
    assert_template 'users/new'
  end
end
