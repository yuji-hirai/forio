RSpec.describe "Like", type: :system, js: true do
  subject { page }

  let(:like) { build(:like) }
  let(:user) { build(:user) }
  let(:post) { build(:post) }

  before do
    sign_up(user)
    post_create(post)
  end

  it "ajaxでいいねボタンの表示が切り替わること" do
    is_expected.to have_css '#like-btn'
    is_expected.not_to have_css '#unlike-btn'
    find('#like-btn').click
    wait_for_ajax
    is_expected.to have_css '#unlike-btn'
    is_expected.not_to have_css '#like-btn'
    find('#unlike-btn').click
    wait_for_ajax
    is_expected.to have_css '#like-btn'
    is_expected.not_to have_css '#unlike-btn'
  end

  it "いいねすると、いいね一覧に表示されること" do
    is_expected.to have_css '#like-btn'
    is_expected.not_to have_css '#unlike-btn'
    find('#like-btn').click
    visit likes_index_path
    is_expected.to have_css '#unlike-btn'
    is_expected.not_to have_css '#like-btn'
    is_expected.to have_content 'test_title'
    is_expected.to have_content "test_tag"
    is_expected.to have_content 'コメント 0件'
    is_expected.to have_content user.name
    is_expected.to have_css ".icon_mini"
    is_expected.to have_selector "img[src$='test_post_img.jpg']"
  end
end
