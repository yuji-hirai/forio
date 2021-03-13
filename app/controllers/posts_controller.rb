class PostsController < ApplicationController
  before_action :set_target_post, only: [:show, :edit, :update, :destroy]
  PER = 8
  def index
    @posts = Post.page(params[:page]).per(PER)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    # @post.user_id = current_user.id
    if @post.save
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
  end

  def update
    if @post.update(post_params)
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
    @post = Post.find(params[:id])
  end
end
