# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_and_authenticate(params[:session][:email], params[:session][:password])
    if user.present?
      session[:user_id] = user.id
      flash[:success] = 'You have successfully logged in'
      redirect_to user_path(user)
    else
      flash.now[:danger] = 'There was something wrong with your login information'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'You have logged out'
    redirect_to root_path
  end
end
