class CommentsController < ApplicationController
  before_action :set_target_post, only: [:create, :destroy]

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user_id = current_user.id
    respond_to do |format|
      if @comment.save
        format.js { render 'comment_ajax.js.erb' }
      else
        format.html { redirect_to @post }
      end
    end

    # コメントすると、通知する
    @post.create_notification_comment!(current_user, @comment.id)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    render "comments/comment_ajax.js.erb"
  end

  private

  def set_target_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:post_id, :user_id, :content, :image)
  end
end
