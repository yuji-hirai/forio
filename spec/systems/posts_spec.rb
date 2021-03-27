RSpec.describe "Posts", type: :system do
  subject { page }

  let(:post) { build(:post) }
  let(:user) { build(:user) }
  let(:other_user) { build(:user) }

  before do
    sign_up(user)
    visit new_post_path
  end

  describe "投稿" do
    it "有効な値を入力すると、投稿一覧に表示されること" do
      post_create(post)
      expect(current_path).to eq posts_path
      is_expected.to have_content "test_titleを投稿しました"
      is_expected.to have_content 'test_title'
      is_expected.to have_content "test_tag"
      is_expected.to have_content 'コメント 0件'
      is_expected.to have_content user.name
      is_expected.to have_css ".icon_mini"
      is_expected.to have_selector "img[src$='test_post_img.jpg']"
    end

    it "無効な値を入力すると、投稿一覧に表示されない" do
      fill_in "投稿タイトル", with: "1" * 61
      fill_in_rich_text_area '投稿内容', with: "test_body"
      click_on "投稿する"
      expect(current_path).to eq posts_path
      is_expected.to have_content "投稿に失敗しました"
      is_expected.not_to have_content 'test_title'
      is_expected.not_to have_content "test_tag"
    end

    it "記事をクリックすると、記事詳細を表示すること" do
      post_create(post)
      find('.post_image_index').click
      expect(current_path).to eq post_path(id: 1)
      is_expected.to have_content 'test_title'
      is_expected.to have_content "test_body"
      is_expected.to have_content "test_tag"
      is_expected.to have_content user.name
      is_expected.to have_css ".icon_mini"
      is_expected.to have_selector "img[src$='test_post_img.jpg']"
      is_expected.to have_button 'コメント'
      is_expected.to have_content 'コメント 0件'
      is_expected.to have_link '編集'
      is_expected.to have_link '削除'
    end
    context "投稿者の場合" do
      it "有効な値の場合更新できること" do
        post_create(post)
        find('.post_image_index').click
        find(".edit-button").click
        expect(current_path).to eq edit_post_path(id: 1)
        fill_in "投稿タイトル", with: "update_title"
        fill_in_rich_text_area "投稿内容", with: "update_body"
        fill_in "タグ", with: "update_tag"
        attach_file '画像', "#{Rails.root}/app/assets/images/update_post_img.jpg"
        click_on "投稿する"
        is_expected.to have_content "update_titleを更新しました"
        expect(current_path).to eq posts_path
        is_expected.to have_content "update_title"
        is_expected.to have_content "update_tag"
        is_expected.to have_selector "img[src$='update_post_img.jpg']"
        is_expected.not_to have_content 'test_title'
        is_expected.not_to have_content "test_tag"
        is_expected.not_to have_selector "img[src$='test_post_img.jpg']"
      end

      it "無効な値の場合更新できないこと" do
        post_create(post)
        find('.post_image_index').click
        find(".edit-button").click
        expect(current_path).to eq edit_post_path(id: 1)
        fill_in "投稿タイトル", with: "1" * 61
        click_on "投稿する"
        expect(current_path).to eq post_path(id: 1)
        is_expected.to have_content "投稿に失敗しました"
        visit current_path
        is_expected.to have_content 'test_title'
        is_expected.not_to have_content "update_title"
      end

      it "削除ボタンを押すと、削除されること" do
        post_create(post)
        find('.post_image_index').click
        find(".alarm").click
        expect do
          expect(page.accept_confirm).to eq "本当に削除しますか？"
          expect(page).to have_content "test_titleを削除しました"
        end.to change(Post, :count).by(-1)
        is_expected.not_to have_content post.title
      end
    end

    context "他のユーザーの場合" do
      it "記事をクリックすると、編集と削除ボタンの表示がないこと" do
        post_create(post)
        visit sign_out_path
        sign_up(other_user)
        visit posts_path
        find('.post_image_index').click
        expect(current_path).to eq post_path(id: 1)
        is_expected.to have_content 'test_title'
        is_expected.to have_content "test_body"
        is_expected.to have_content "test_tag"
        is_expected.to have_content user.name
        is_expected.to have_css ".icon_mini"
        is_expected.to have_selector "img[src$='test_post_img.jpg']"
        is_expected.to have_button 'コメント'
        is_expected.to have_content 'コメント 0件'
        is_expected.not_to have_link '編集'
        is_expected.not_to have_link '削除'
      end
    end
  end

  describe "ページネーション" do
    context "投稿記事数が9以下の場合" do
      it "ページ遷移にできないこと" do
        9.times do |post|
          post_create(post)
        end
        is_expected.not_to have_css ".page-link"
      end
    end

    context "投稿記事数が10以上の場合" do
      it "ページ遷移にできること" do
        10.times do |post|
          post_create(post)
        end
        is_expected.to have_css(".page-link")
        within '.pagination' do
          click_on '2'
        end
        is_expected.to have_content 'test_title'
        is_expected.to have_content 'test_title'
      end
    end
  end

  describe "検索" do
    it "キーワード検索できること" do
      post_create(post)
      other_post_create(post)
      fill_in 'q[title_or_body_or_tags_name_or_user_name_cont]', with: 'other_title'
      click_on "検索"
      is_expected.to have_content 'other_title'
      is_expected.to have_selector "img[src$='other_post_img.jpg']"
      is_expected.not_to have_content 'test_title'
      is_expected.not_to have_selector "img[src$='test_post_img.jpg']"
    end
    it "タグをクリックすると、タグに紐付いた記事のみ表示されること" do
      post_create(post)
      other_post_create(post)
      expect(current_path).to eq posts_path
      is_expected.to have_content 'test_title'
      is_expected.to have_content "#test_tag"
      is_expected.to have_content "other_title"
      is_expected.to have_content "#other_tag"
      click_on "#test_tag"
      is_expected.not_to have_content "other_title"
      is_expected.to have_content 'test_title'
    end
  end
end
