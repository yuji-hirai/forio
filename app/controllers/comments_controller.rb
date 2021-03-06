class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    # @post = @comment.post
    if @comment.save
      redirect_to @comment.post, notice: "#{@post.title}にコメントしました"
    else
      flash.now[:alert] = 'コメントに失敗しました'
      render "posts/show"
    end
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:post_id, :content)
  end
end
