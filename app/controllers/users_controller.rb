class UsersController < ApplicationController
  
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
    
  end
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    @entries =  @user.entries.paginate(page: params[:page], per_page: 5)
    @entry = current_user.entries.build
    respond_to do |format|
      format.html { redirect_to root_url and return unless @user.activated? }
      format.js
    end
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      # log_in @user
      flash.now[:info] = "Please check your email to activate your account."
      # redirect_to root_url
    else
      flash.now[:danger] = "Invalid data input"
      # render 'static_pages/home'
    end

    respond_to do |format|
      # format.html
      format.js
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to root_url
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page], per_page: 8)
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page], per_page: 8)
    render 'show_follow'
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    #confirms the correct user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    #
    def admin_user
      redirect_to users_path unless current_user.admin?
    end
end
