RSpec.describe "Notification", type: :system do
  subject { page }

  let(:user) { build(:user) }
  let(:other_user) { build(:user, name: 'othername') }
  let(:aother_user) { build(:user) }
  let(:post) { build(:post) }

  before do
    sign_up(user)
    post_create(post)
    visit sign_out_path
    sign_up(other_user)
  end

  it "いいねされると通知されること" do
    find('#like-btn').click
    visit sign_out_path
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
    find(".navbar-toggler-icon").click
    is_expected.to have_content "new"
    visit notifications_path
    is_expected.to have_link "あなたの投稿にいいねしました"
  end
  it "フォローされると通知されること" do
    visit user_path(id: 1)
    click_on "フォローする"
    visit sign_out_path
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
    visit notifications_path
    is_expected.to have_content "あなたをフォローしました"
  end

  it "コメントされると通知されること" do
    find('.post_image_index').click
    find('#textarea-comment').set("いい記事ですね")
    click_on 'コメント'
    visit sign_out_path
    sign_in(user)
    visit notifications_path
    is_expected.to have_content "あなたの投稿にコメントしました"
  end

  it "コメントした記事に、コメントされると通知されること" do
    find('.post_image_index').click
    find('#textarea-comment').set("いい記事ですね")
    click_on 'コメント'
    visit sign_out_path
    sign_up(aother_user)
    find('.post_image_index').click
    find('#textarea-comment').set("わかりやすいです")
    click_on 'コメント'
    visit sign_out_path
    sign_in(other_user)
    visit notifications_path
    is_expected.to have_link "#{aother_user.name} さんが"
    is_expected.to have_link "#{user.name}さんの投稿にコメントしました"
  end

  it "全削除ボタンを押すと、通知一覧が削除されること" do
    find('#like-btn').click
    visit sign_out_path
    sign_in(user)
    visit notifications_path
    is_expected.to have_link "あなたの投稿にいいねしました"
    click_on "通知全削除"
    is_expected.to have_content "通知を削除しました"
    is_expected.to have_content "通知はありません"
    is_expected.not_to have_link "あなたの投稿にいいねしました"
  end
end
