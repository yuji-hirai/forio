class PostsController < ApplicationController
  before_action :set_target_post, only: [:show, :edit, :update, :destroy]
  PER = 8
  def index
    if params[:search].present?
      posts = Post.posts_search(params[:search])
    elsif params[:tag_id].present?
      @tag = Tag.find(params[:tag_id])
      posts = @tag.posts.order(created_at: :desc)
    else
      posts = Post.all.order(created_at: :desc)
    end

    @tag_lists = Tag.all
    @posts = Kaminari.paginate_array(posts).page(params[:page]).per(PER)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    # 半角or全角スペース区切りで真であれば、タグをtag_listに追加する
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
    @comments = @post.comments.includes(:user)
  end

  def edit
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
    params.require(:post).permit(:title, :body, images: []).merge(user_id: current_user.id)
  end

  def set_target_post
    @post = Post.find(params[:id])
  end
end
