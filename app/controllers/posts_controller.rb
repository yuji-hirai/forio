class PostsController < ApplicationController
  before_action :set_target_post, only: [:show, :update, :destroy]
  PER = 9
  def index
    @q = Post.includes(:tags, :rich_text_body).ransack(params[:q])
    if params[:tag_id].present?
      @tag = Tag.find(params[:tag_id])
      posts = @tag.posts
    else
      posts = @q.result(distinct: true)
    end

    @tag_lists = Tag.all.includes(:posts)
    @posts = Kaminari.paginate_array(posts.includes({ post_tags: :tag }, :user).with_attached_image.order(created_at: :desc)).page(params[:page]).per(PER)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    # 半角or全角スペース区切りで、タグとしてtag_listに追加する
    tag_list = params[:post][:name].split(/[[:blank:]]+/).select(&:present?)
    if @post.save
      @post.save_tags(tag_list)
      redirect_to posts_path, notice: "#{@post.title}を投稿しました"
    else
      flash.now[:alert] = '投稿に失敗しました'
      render "new"
    end
  end

  def show
    @comment = Comment.new(post_id: @post.id)
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(" ")
  end

  def update
    tag_list = params[:post][:name].split(/[[:blank:]]+/).select(&:present?)
    if @post.update(post_params)
      @post.save_tags(tag_list)
      redirect_to posts_path, notice: "#{@post.title}を更新しました"
    else
      flash.now[:notice] = '投稿に失敗しました'
      render "edit"
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "#{@post.title}を削除しました"
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image).merge(user_id: current_user.id)
  end

  def set_target_post
    @post = Post.with_attached_image.find(params[:id])
  end
end
