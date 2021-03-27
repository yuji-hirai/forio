RSpec.describe "Comment", type: :system, js: true do
  subject { page }

  let(:user) { build(:user) }
  let(:other_user) { build(:user) }
  let(:post) { build(:post) }

  before do
    sign_up(user)
    post_create(post)
  end

  it "ajaxで記事にコメントできること" do
    find('.post_image_index').click
    find('#textarea-comment').set("コメントお待ちしております")
    click_on 'コメント'
    wait_for_ajax
    is_expected.to have_content "コメント 1件"
    is_expected.to have_content user.name
    is_expected.to have_content "コメントお待ちしております"
    is_expected.to have_content "1分以内前"
    is_expected.to have_css ".fa-trash"
    visit sign_out_path
    sign_up(other_user)
    visit posts_path
    find('.post_image_index').click
    find('#textarea-comment').set("いいですね")
    click_on 'コメント'
    wait_for_ajax
    is_expected.to have_content "コメント 2件"
    is_expected.to have_content other_user.name
    is_expected.to have_content "いいですね"
    is_expected.to have_content "1分以内前"
    is_expected.to have_css ".fa-trash"
  end

  it "コメント本人はコメントを削除できること" do
    find('.post_image_index').click
    find('#textarea-comment').set("コメントお待ちしております")
    click_on 'コメント'
    find('.fa-trash').click
    wait_for_ajax
    is_expected.to have_content "コメント 0件"
  end

  it "コメント本人でなければ、コメントを削除できないこと" do
    find('.post_image_index').click
    find('#textarea-comment').set("コメントお待ちしております")
    click_on 'コメント'
    visit sign_out_path
    sign_up(other_user)
    visit posts_path
    find('.post_image_index').click
    is_expected.not_to have_css ".fa-trash"
    is_expected.to have_content "コメント 1件"
  end
end
