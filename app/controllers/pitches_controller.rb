class PitchesController < ApplicationController

  before_action :load_all_pitches

  def index
  end

  def individual
  end

  def business
  end

  def search
  search = params[:q]
  @pitches = Pitch.where('lower(body) like ?', "%#{search}%")
  end


  def new
    @pitch = Pitch.new
    @user = User.find(session[:user_id])
    @user_type = @user.user_type
  end

  def show
    @pitch = Pitch.find(params[:id])
    @story = Story.find(params[:story_id])
  end

  def destroy
    pitch = Pitch.find(params[:id])
    story = Story.find(params[:story_id])
    pitch.delete
    redirect_to story_path(story)
  end

  def create
    pitch = Pitch.create(pitch_params)
    story = Story.find(params[:story_id])
    pitch.story_id = params[:story_id]
    pitch.save
    redirect_to story_path(story)
  end

  def edit
    @pitch = Pitch.find(params[:id])
    if @pitch.user.email == session[:user_email] || admin?
      render :edit
    else
      redirect_to root_path
    end
  end

  def update
    story = Story.find(params[:story_id])
    pitch = Pitch.find(params[:id])
    pitch.update(pitch_params)
    redirect_to story_pitch_path(story, pitch)
  end

  helper_method :authorized?
  helper_method :admin?

  def authorized?
    current_user_email = @pitch.user.email
    sessions_email = session[:user_email]
    current_user_email == sessions_email
  end

  def admin?
    session[:user_role] == "admin"
  end

  def load_all_pitches
    @pitches = Pitch.all.reverse
  end

  private
  def pitch_params
    params.require(:pitch).permit(:body, :user_type)
  end






end

