class LikesController < ApplicationController
  before_action :post_params, only: [:create, :destroy]
  PER = 9
  def index
    like_posts = current_user.like_posts
    @q = like_posts.includes(:tags).ransack(params[:q])
    if params[:tag_id].present?
      @tag = Tag.find(params[:tag_id])
      like_posts = @tag.like_posts
    else
      like_posts = @q.result(distinct: true)
    end

    @tag_lists = Tag.all.includes(:posts)
    @like_posts = Kaminari.paginate_array(like_posts.includes({ post_tags: :tag }, user: [avatar_attachment: :blob]).with_attached_image.order(created_at: :desc)).page(params[:page]).per(PER)
  end

  def create
    Like.create(user_id: current_user.id, post_id: params[:id])
    # いいねすると投稿者に通知する
    @post.create_notification_like!(current_user)
  end

  def destroy
    Like.find_by(user_id: current_user.id, post_id: params[:id]).destroy
  end

  def save_tags(tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags

    # 古いタグを削除
    old_tags.each do |old_name|
      self.tags.delete(Tag.find_by(name: old_name))
    end

    # 新しいタグを追加
    new_tags.each do |new_name|
      post_tag = Tag.find_or_create_by(name: new_name)
      self.tags << post_tag
    end
  end

  private

  def post_params
    @post = Post.find(params[:id])
  end
end
