class UsersController < ApplicationController
  def index
    @users = User.all.order(created_at: :desc).with_attached_avatar
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.includes([:post_tags, :tags]).with_attached_image
  end

  def following
    # @userがフォローしているユーザー
    @user = User.find(params[:id])
    @users = @user.following.with_attached_avatar
    render 'show_follow'
  end

  def followers
    # @userをフォローしているユーザー
    @user = User.find(params[:id])
    @users = @user.followers.with_attached_avatar
    render 'show_follower'
  end
end
