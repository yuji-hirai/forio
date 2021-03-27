RSpec.describe "User", type: :system do
  subject { page }

  let(:user) { build(:user) }
  let(:other_user) { build(:user) }

  describe "新規登録" do
    context "有効な値を入力する場合" do
      it "登録されること" do
        sign_up(user)
        is_expected.to have_content 'アカウント登録が完了しました。'
        expect(current_path).to eq posts_path
      end
    end

    context "無効の値を入力する場合" do
      it "登録されないこと" do
        visit new_user_registration_path
        fill_in '名前', with: "user.name"
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        fill_in '確認用パスワード', with: 'test_password_confirmation'
        click_button '登録'
        expect(current_path).to eq user_registration_path
        is_expected.to have_content 'エラーが発生したため ユーザ は保存されませんでした。'
      end

      it "同じデータでは登録されないこと" do
        sign_up(user)
        is_expected.to have_content 'アカウント登録が完了しました。'
        visit sign_out_path
        sign_up(user)
        is_expected.to have_content 'エラーが発生したため ユーザ は保存されませんでした。'
      end
    end
  end

  describe 'ログインとログアウト' do
    context "ログイン" do
      before do
        sign_up(user)
        visit sign_out_path
        visit new_user_session_path
      end

      it '有効な値の場合、成功する' do
        fill_in "メールアドレス", with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'
        is_expected.to have_content 'ログインしました。'
      end

      it 'headerのリンクが有効なこと' do
        fill_in "メールアドレス", with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'
        is_expected.to have_link nil, href: root_path
        find(".navbar-toggler-icon").click
        is_expected.to have_link '投稿', href: new_post_path
        is_expected.to have_link '投稿一覧', href: posts_path
        is_expected.to have_link 'いいね一覧', href: likes_index_path
        is_expected.to have_link '通知', href: notifications_path
        is_expected.to have_link 'プロフィール', href: user_path(id: 1)
        is_expected.to have_link 'ユーザー一覧', href: users_path
        is_expected.to have_link 'ログアウト', href: sign_out_path
        is_expected.not_to have_link '登録', href: new_user_registration_path
        is_expected.not_to have_link 'ログイン', href: new_user_session_path
      end

      it '無効の値の場合、失敗する' do
        fill_in 'メールアドレス', with: 'test_name@yahoo.co.jp'
        fill_in 'パスワード', with: 'test_password'
        click_button 'ログイン'
        expect(current_path).to eq new_user_session_path
        is_expected.to have_content 'メールアドレスまたはパスワードが違います。'
        is_expected.to have_link nil, href: root_path
      end
    end

    context "ログアウト " do
      subject { page }

      before { sign_up(user) }

      it 'トップページに戻ること' do
        find(".navbar-toggler-icon").click
        click_link 'ログアウト'
        is_expected.to have_content 'ログアウトしました。'
        # is_expected.to eq root_path
      end
      it 'headerのリンクが有効なこと' do
        visit sign_out_path
        is_expected.to have_link '登録', href: new_user_registration_path
        is_expected.to have_link 'ログイン', href: new_user_session_path
        is_expected.not_to have_selector('#navbar-toggler')
        is_expected.not_to have_link '投稿', href: new_post_path
        is_expected.not_to have_link '投稿一覧', href: posts_path
        is_expected.not_to have_link 'いいね一覧', href: likes_index_path
        is_expected.not_to have_link '通知', href: notifications_path
        is_expected.not_to have_link 'プロフィール', href: user_path(id: 1)
        is_expected.not_to have_link 'ユーザー一覧', href: users_path
        is_expected.not_to have_link 'ログアウト', href: sign_out_path
      end
    end
  end

  describe 'ユーザー編集' do
    before { sign_up(user) }

    context '有効な値の場合' do
      it '編集すると、成功すること' do
        visit edit_user_registration_path(user)
        fill_in 'メールアドレス', with: 'update@example.com'
        click_button '更新'
        is_expected.to have_content 'アカウント情報を変更しました。'
        expect(current_path).to eq user_path(id: 1)
      end

      it '画像と自己紹介文を追加すると、成功すること' do
        visit edit_user_registration_path(user)
        fill_in_rich_text_area '自己紹介文', with: 'こんにちわ'
        attach_file '画像', "#{Rails.root}/app/assets/images/default_user.png"
        click_button '更新'
        is_expected.to have_content 'アカウント情報を変更しました。'
        expect(current_path).to eq user_path(id: 1)
      end
    end

    context '無効の値の場合' do
      it '編集が失敗' do
        visit edit_user_registration_path(user)
        fill_in '名前', with: "1" * 51
        click_button '更新'
        is_expected.to have_content 'エラーが発生したため ユーザ は保存されませんでした。'
      end
    end
  end

  describe 'アカウント削除' do
    it "成功すること" do
      sign_up(other_user)
      visit edit_user_registration_path(other_user)
      click_button 'アカウント削除'
      expect do
        expect(page.accept_confirm).to eq "本当に削除しますか？"
        is_expected.to have_content 'アカウントを削除しました。'
      end.to change(User, :count).by(-1)
      is_expected.not_to have_content other_user.name
    end
  end

  describe "フラッシュメッセージ" do
    it '残留しないこと' do
      sign_up(user)
      aggregate_failures do
        expect(current_path).to eq posts_path
        expect(has_css?('.alert-info')).to be_truthy
        visit current_path
        expect(has_css?('.alert-info')).to be_falsy
      end
    end
  end
end
