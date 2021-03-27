RSpec.describe "Relationship", type: :system, js: true do
  subject { page }

  let(:user) { build(:user) }
  let(:other_user) { build(:user) }

  before do
    sign_up(other_user)
    visit sign_out_path
    sign_up(user)
    visit user_path(id: 1)
  end

  it "ajaxでフォローボタンとフォロー解除ボタンの表示が切り替わること" do
    is_expected.not_to have_button 'フォロー解除'
    click_on "フォローする"
    wait_for_ajax
    is_expected.to have_button 'フォロー解除'
    is_expected.not_to have_button 'フォローする'
    click_on "フォロー解除"
    wait_for_ajax
    is_expected.to have_button 'フォローする'
  end

  it "フォローすると、ajaxでフォロワーが1増えること" do
    is_expected.to have_content 'フォロワー0'
    is_expected.to have_content 'フォロー0'
    click_on "フォローする"
    wait_for_ajax
    is_expected.to have_content 'フォロワー1'
    is_expected.to have_content 'フォロー0'
    visit user_path(id: 2)
    is_expected.to have_content 'フォロワー0'
    is_expected.to have_content 'フォロー1'
  end

  it "フォローすると、フォロー一覧に表示されること" do
    click_on "フォローする"
    wait_for_ajax
    visit user_path(id: 2)
    click_on 'フォロー1'
    expect(page).to have_content 'フォローユーザー一覧'
    within '.card-follow-user' do
      is_expected.to have_content other_user.name
      is_expected.not_to have_content user.name
    end
  end

  it "フォローすると、フォロワー側のフォロワー一覧に表示されること" do
    click_on "フォローする"
    wait_for_ajax
    click_on 'フォロワー1'
    expect(page).to have_content 'フォロワーユーザー一覧'
    within '.card-follow-user' do
      is_expected.to have_content user.name
      is_expected.not_to have_content other_user.name
    end
  end
end
