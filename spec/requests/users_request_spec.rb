require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }
  let(:user_params) { attributes_for(:user) }
  let(:no_name_user) { create(:user, name: "") }
  let(:no_name_user_params) { attributes_for(:user, name: "") }
  let(:new_user_params) { attributes_for(:user, name: "after_update") }
  let(:invalid_new_user_params) { attributes_for(:user, name: nil) }

  let(:guest_user) { create(:user, email: "guest@example.com", password: "guests", password_confirmation: "guests") }
  let(:guest_user_params) { attributes_for(:user, email: "guest@example.com", password: "guests", password_confirmation: "guests") }

  describe "GET /users/sign_up" do
    it "新規登録画面の表示に成功すること" do
      get new_user_registration_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /users/sign_in" do
    it "ログイン画面の表示に成功すること" do
      get new_user_session_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /users/sign_in" do
    it "有効な値の場合、ログインに成功すること" do
      post user_session_path, params: { user: user_params }
      expect(response).to have_http_status(200)
    end

    it "無効な値の場合、ログインに失敗すること" do
      post user_session_path, params: { user: no_name_user_params }
      expect(response.body).to include 'メールアドレスまたはパスワードが違います。'
    end
  end

  describe "DELETE /users/sign_out" do
    before do
      sign_in user
      sign_in guest_user
    end

    it "ユーザーはログアウトに成功すること" do
      delete destroy_user_session_path
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end

    it "ゲストユーザーはログアウトに成功すること" do
      delete destroy_user_session_path
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end
  end

  describe "POST /users(user_registration)" do
    context "有効な値の場合" do
      it 'ユーザーが登録されること' do
        expect do
          post user_registration_path, params: { user: user_params }
        end.to change(User, :count).by(1)
      end

      it "記事一覧にリダレクトされること" do
        post user_registration_path, params: { user: user_params }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to posts_path
      end
    end

    context "無効な値の場合" do
      it '登録に失敗すること' do
        post user_registration_path, params: { user: no_name_user_params }
        expect(response.body).to include '名前を入力してください'
      end
    end
  end

  describe 'GET /users/edit' do
    it 'ログインユーザーの場合,リクエストが成功すること' do
      sign_in user
      get edit_user_registration_path
      expect(response).to have_http_status(200)
    end

    it '未ログインの場合,ログイン画面にリダレクトされること' do
      sign_out user
      get edit_user_registration_path
      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'PATCH /users' do
    context "ログインユーザーの場合" do
      before { sign_in user }

      it "値が有効の場合、更新が成功すること" do
        patch user_registration_path, params: { user: new_user_params }
        user.reload
        expect(user.name).to eq "after_update"
      end

      it "値が無効の場合、更新が失敗すること" do
        patch user_registration_path, params: { user: invalid_new_user_params }
        user.reload
        expect(user.name).not_to eq "after_update"
      end
    end

    context "未ログインの場合" do
      it "ログイン画面にリダイレクトされること" do
        sign_out user
        patch user_registration_path, params: { user: new_user_params }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "DELETE /users" do
    it "ユーザーの削除に成功すること" do
      sign_in user
      expect do
        delete user_registration_path
      end.to change(User, :count).from(1).to(0)
    end
  end

  describe "POST /users/guest_sign_in" do
    it "ゲストユーザーとしてログインできること" do
      post guest_sign_in_path, params: { user: guest_user_params }
      expect(response).to have_http_status(302)
      expect(response).to redirect_to posts_path
    end
  end

  describe "GET /users" do
    it "ログインユーザーの場合,ユーザー一覧の表示に成功すること" do
      sign_in user
      get users_path
      expect(response).to have_http_status(200)
    end

    it "未ログインの場合,ログイン画面にリダイレクトされること" do
      sign_out user
      get users_path
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "GET /users/:id" do
    it "ログインユーザーの場合,ユーザー詳細の表示に成功すること" do
      sign_in user
      get users_path(user.id)
      expect(response).to have_http_status(200)
    end

    it "未ログインの場合,ログイン画面にリダイレクトされること" do
      sign_out user
      get users_path(user.id)
      expect(response).to have_http_status(401)
    end
  end
end
