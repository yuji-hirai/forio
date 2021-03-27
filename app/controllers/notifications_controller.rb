class NotificationsController < ApplicationController
  PER = 8
  def index
    @notifications = current_user.passive_notifications.includes(:visited, visitor: :avatar_attachment, post: { user: [avatar_attachment: :blob] })
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end

  def destroy
    @notifications = current_user.passive_notifications.destroy_all
    redirect_to notifications_path, notice: "通知を削除しました"
  end
end
