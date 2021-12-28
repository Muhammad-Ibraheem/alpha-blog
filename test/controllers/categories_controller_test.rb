# frozen_string_literal: true

require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @category = Category.create(name: 'sports')
    @user = User.create(username: 'ibraheem', email: 'ibraheem@example.com', password: 'password', admin: true)
  end

  test 'should get categories index' do
    get '/categories'
    assert_response :success
  end

  test 'should get new' do
    sign_in_as(@user, 'password')
    get '/categories/new'
    assert_response :success
  end

  test 'should get show' do
    get "/categories/#{@category.id}"
    assert_response :success
  end

  test 'should redirect create when admin not logged in' do
    assert_no_difference 'Category.count' do
      post categories_path, params: { category: { name: 'sports' } }
    end
    assert_redirected_to categories_path
  end
end
