class PeopleController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :follow, :unfollow]

  def index
    # Fetch all users, excluding the current user, ordered by creation date
    @users = User.where.not(id: current_user.id).order(created_at: :asc) if user_signed_in?
    @users ||= User.all.order(created_at: :asc) # Fallback if not signed in

    # Eager load avatars for performance
    @users = @users.includes(:avatar_attachment, :avatar_blob)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
  end

  def follow
    current_user.follow(@user)

    respond_to do |format|
      format.html do
        render inline: "<div id='user_<%= @user.id %>_follow_button_container'><%= render 'people/follow_button', user: @user, current_user: current_user %></div>", 
               layout: false
      end
    end
  rescue ActiveRecord::RecordInvalid
    respond_to do |format|
      format.html do
        render inline: "<div id='user_<%= @user.id %>_follow_button_container'><%= render 'people/follow_button', user: @user, current_user: current_user %></div>", 
               layout: false
      end
    end
  end

  def unfollow
    current_user.unfollow(@user)

    respond_to do |format|
      format.html do
        render inline: "<div id='user_<%= @user.id %>_follow_button_container'><%= render 'people/follow_button', user: @user, current_user: current_user %></div>", 
               layout: false
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
