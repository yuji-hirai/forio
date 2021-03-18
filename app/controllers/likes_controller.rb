class LikesController < ApplicationController
  before_action :post_params, only: [:create, :destroy]

  def index
    @like_posts = current_user.like_posts.includes([:user])
  end

  def create
    Like.create(user_id: current_user.id, post_id: params[:id])
    # いいねすると投稿者に通知する
    @post.create_notification_like!(current_user)
  end

  def destroy
    Like.find_by(user_id: current_user.id, post_id: params[:id]).destroy
  end

  private

  def post_params
    @post = Post.find(params[:id])
  end
end
