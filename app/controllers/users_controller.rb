class UsersController < ApplicationController
  def index
    @users = User.all.order(created_at: :desc)
  end

  def show
    @user = User.find(params[:id])
  end

  def following
    # @userがフォローしているユーザー
    @user = User.find(params[:id])
    @users = @user.following
    render 'show_follow'
  end

  def followers
    # @userをフォローしているユーザー
    @user = User.find(params[:id])
    @users = @user.followers
    render 'show_follower'
  end
end
