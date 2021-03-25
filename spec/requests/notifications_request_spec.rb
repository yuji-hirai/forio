require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:notification) { create(:notification, visitor_id: user.id, visited_id: other_user.id, action: 'like') }

  describe "GET /notifications" do
    it "ログインユーザーの場合、通知画面が表示されること" do
      sign_in user
      get "/notifications"
      expect(response).to have_http_status(200)
    end

    it "未ログイン場合、ログイン画面にリダイレクトされること" do
      sign_out user
      get "/notifications"
      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end
  end
end
