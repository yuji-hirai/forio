class CommentsController < ApplicationController
  before_action :set_target_post, only: [:create, :destroy]
  def create
    @comment = @post.comments.new(comment_params)

    if @comment.save
      redirect_to @post, notice: "#{@post.title}にコメントしました"
    else
      redirect_to @post, alert: "#{@post.title}のコメントに失敗しました"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to @post, alert: "#{@post.title}コメントを削除しました"
  end

  private

  def set_target_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:post_id, :content, :image).merge(user_id: current_user.id)
  end
end
