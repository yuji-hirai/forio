class CommentsController < ApplicationController
  before_action :set_target_post, only: [:create, :destroy]

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash.now[:notice] = "#{@post.title}にコメントしました"
      render 'comment_ajax.js.erb'
    else
      flash.now[:alert] = "#{@post.title}のコメントに失敗しました"
      render "comments/index"
    end
    # コメントすると、通知する
    @post.create_notification_comment!(current_user, @comment.id)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash.now[:alert] = "#{@post.title}コメントを削除しました"
    render 'comment_ajax.js.erb'
  end

  private

  def set_target_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:post_id, :user_id, :content, :image)
  end
end
