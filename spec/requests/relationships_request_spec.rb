require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:relationship) { user.following_relationships.create(following_id: other_user.id) }

  describe "GET /users/:id/following" do
    it 'ログインユーザーの場合、フォロー一覧画面が表示されること' do
      sign_in user
      get following_user_path(user)
      expect(response).to have_http_status(200)
    end

    it '未ログインの場合、ログイン画面にリダイレクトされること' do
      sign_out user
      get following_user_path(user)
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "GET /users/:id/followers" do
    it 'ログインユーザーの場合、フォロワー一覧画面が表示されること' do
      sign_in user
      get followers_user_path(user)
      expect(response).to have_http_status(200)
    end

    it '未ログインの場合、ログイン画面にリダイレクトされること' do
      sign_out user
      get followers_user_path(user)
      expect(response).to redirect_to new_user_session_path
    end
  end
end
