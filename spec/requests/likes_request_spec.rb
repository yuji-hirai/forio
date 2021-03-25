require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let(:user) { create(:user) }
  let(:like) { create(:like) }

  describe "GET /likes/index" do
    it 'ログインユーザーの場合、いいね一覧画面が表示されること' do
      sign_in user
      get likes_index_path
      expect(response).to have_http_status(200)
    end

    it '未ログインの場合、ログイン画面にリダイレクトされること' do
      sign_out user
      get likes_index_path
      expect(response).to redirect_to new_user_session_path
    end
  end
end
