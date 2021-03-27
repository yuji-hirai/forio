module SignIn
  def sign_up(user)
    visit new_user_registration_path
    fill_in '名前', with: user.name
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'test_password'
    fill_in '確認用パスワード', with: 'test_password'
    click_button '登録'
  end

  def sign_in(user)
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end
end
