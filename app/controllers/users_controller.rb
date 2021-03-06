# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  load_and_authorize_resource only: %i[edit update destroy]

  def index
    @users = User.paginate(page: params[:page], per_page: 3)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.add_role params[:user][:role]
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to the Alpha Blog #{@user.username}"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = 'Your account was updated successfuly'
      redirect_to articles_path

    else
      render 'edit'
    end
  end

  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def destroy
    @user = User.find_by(id: session[:id])
    @user.destroy
    flash[:danger] = 'User and all articles created by user have been deleted'
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if (current_user != @user) && !current_user.admin?
      flash[:danger] = 'you can only edit your own account'
      redirect_to root_path
    end
  end
end
