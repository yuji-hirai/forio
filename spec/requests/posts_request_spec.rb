require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  describe "GET /posts" do
    it "ログインユーザーの場合、記事一覧画面が表示されること" do
      sign_in user
      get posts_path
      expect(response).to have_http_status(200)
    end

    it "未ログイン場合、ログイン画面にリダイレクトされること" do
      sign_out user
      get posts_path
      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "GET /posts/:id" do
    it "ログインユーザーの場合、記事詳細画面が表示されること" do
      sign_in user
      get edit_post_path(post.id)
      expect(response).to have_http_status(200)
    end

    it "未ログイン場合、ログイン画面にリダイレクトされること" do
      sign_out user
      get edit_post_path(post.id)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "GET /posts/new" do
    it "ログインユーザーの場合、投稿画面が表示されること" do
      sign_in user
      get new_post_path
      expect(response).to have_http_status(200)
    end

    it "未ログイン場合、ログイン画面にリダイレクトされること" do
      sign_out user
      get new_post_path
      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "GET /posts/:id/edit" do
    it "ログインユーザーの場合、記事編集画面が表示されること" do
      sign_in user
      get edit_post_path(post.id)
      expect(response).to have_http_status(200)
    end

    it "未ログイン場合、ログイン画面にリダイレクトされること" do
      sign_out user
      get edit_post_path(post.id)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end
  end
end
