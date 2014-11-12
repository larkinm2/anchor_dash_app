class UsersController < ApplicationController

before_action :load_user, only: [:show, :edit, :destroy, :update,]
before_action :authenticate, only: [:show, :edit, :destroy, :update,]
before_action :authorize, only: [:show, :edit, :destroy, :update,]


  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    @user.user_type = params[:user_type]
    @user.save
    session[:user_id] = @user.id
    session[:user_email] = @user.email
    session[:user_role] = @user.role
    redirect_to user_path(@user)
  end

  def destroy
    user = User.find(params[:id])
    user.delete
    session[:user_id] = nil
    session[:user_email] = nil
    session[:user_role] = nil
    redirect_to root_path
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    # binding.pry
    user = User.find(params[:id])
    # binding.pry
    user.update(user_params)
    # binding.pry
    user.save
    # binding.pry
    redirect_to user_path(user)
  end

  private
  # these are helper funcitons
  def user_params
    params.require(:user).permit(:password, :first_name, :last_name, :email, :phone, :company, :user_type)
  end

  # def user_exists?
  #   redirect_to root_path if !User.exists?(params[:id])
  # end

  def load_user

    @user = User.find_by(id: params[:id])
    redirect_to root_path if !@user

  end

  def authenticate
    redirect_to root_path if !logged_in?#if the sessions u?er is returning nil, let's redirect to login
  end

  def authorize
    if current_user != @user #here we are making sure that the user coming from params is the same as the user in params
      redirect_to user_path(current_user)
    end
  end

end
