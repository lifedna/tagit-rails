class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = t(:welcome_message)
      redirect_to @user
    else
      render "new"
    end
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page])
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = t(:profile_updated_message)
      sign_in @user
      redirect_to @user
    else
      render "edit"
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t(:user_deleted_message)
    redirect_to users_url
  end
  
private
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless is_current_user?(@user)
  end
  
  def admin_user
    unless current_user.admin?
      flash[:notice] = t(:deny_access_message)
      redirect_to(root_path)
    end
  end
end
