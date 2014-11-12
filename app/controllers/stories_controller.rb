class StoriesController < ApplicationController
  before_action :load_user, only: [:index, :create, :destroy, :update,]
  before_action :load_story, only: [:show, :edit]

  def index
    @user = User.find(session[:user_id])
  end

  def new
    @story = Story.new
    @user_id = session[:user_id]
    @user = User.find(@user_id)
    # binding.pry
    if @user.user_type == "individual"
      render :individual_form
    elsif @user.user_type == "company"
      render :company_form
    else
      redirect_to root_path
    end
  end

  def show
    #need two pages here, if @story.user.user_type ==,,etc
    if @story.user.user_type == "company"
      render :company_story
    elsif @story.user.user_type == "individual"
      render :individual_story
    else
      redirect_to root_path
    end
  end

  def all_stories
    @stories = Story.all
    render :all_stories
  end

  def edit
    if @story.user.email == session[:user_email] || session[:user_role] == "admin"
      if @story.user.user_type == "individual"
      render :edit_individual
      else
      render :edit_company
      end
    else
      redirect_to root_path
    end
    #will need two renders here as well for editing a story
  end

  def update
    story = Story.find(params[:id])
    story.update(story_params)
    redirect_to story_path(story)
  end

  def destroy
    story = Story.find(params[:id])
    user = story.user_id
    story.destroy
    redirect_to user_path(user)
  end

  def create
    user = User.find(session[:user_id])
    story = Story.create(story_params)
    story.user = user
    story.save
    redirect_to user_path(user)
  end

  def load_story
    @story = Story.find(params[:id])
  end

  def authorized?
    current_user_email = @story.user.email
    sessions_email = session[:user_email]
    current_user_email == sessions_email
  end

  def admin?
    session[:user_role] == "admin"
  end

  helper_method :authorized?
  helper_method :admin?

  private

  def story_params
    params.require(:story).permit(:url, :description, :ruby, :python, :ruby_on_rails, :personal_site, :html, :css, :javascript,
      :product_management, :project_management, :marketing, :ux_design, :redis, :postgresql, :mysql, :personal_location, :personal_description,
      :image_url, :business_name, :logo_url, :business_location, :business_description, :industry, :founders, :linked_in, :size, :year_founded, :nickname, :skills)
  end


  def load_user
    @user = User.find(session[:user_id])
  end

  def load_story
    @story = Story.find(params[:id])
  end



end

