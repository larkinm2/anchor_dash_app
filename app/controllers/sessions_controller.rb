class SessionsController < ApplicationController

  def new
  end

  def index
    if session[:user_id]
      user = User.find(session[:user_id])
      session[:user_email] = user.email
      session[:user_role] = user.role
      redirect_to(user_path(user))
    else
    redirect_to login_path
    end
  end

  def create
    user = User.find_by(email: params[:email])
    user = user.authenticate(params[:password]) if user #one line if statement
    if user
      session[:user_id] = user.id
      session[:user_email] = user.email
      session[:user_role] = user.role
      redirect_to(user_path(user))
    else
      flash[:error] = "Sorry! Your password or username is wrong. Please try again!"
      redirect_to(login_path)
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to(root_path)
  end

end
