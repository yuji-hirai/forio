class LikesController < ApplicationController
  before_action :post_params, only: [:create, :destroy]
  PER = 9
  def index
    @tag_lists = Tag.all.includes(:posts)
    like_posts = current_user.like_posts
    @like_posts = Kaminari.paginate_array(like_posts.includes({ post_tags: :tag }, :user).with_attached_images.order(created_at: :desc)).page(params[:page]).per(PER)
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
