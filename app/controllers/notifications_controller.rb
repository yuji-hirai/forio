class NotificationsController < ApplicationController
  PER = 8
  def index
    @notifications = current_user.passive_notifications.page(params[:page]).per(PER).includes(:visitor, :visited, [post: :user])
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end

  def destroy
    @notifications = current_user.passive_notifications.destroy_all
    redirect_to notifications_path, notice: "通知を削除しました"
  end
end
