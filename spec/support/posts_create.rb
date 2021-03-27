module PostCreate
  def post_create(post)
    visit new_post_path
    fill_in "投稿タイトル", with: 'test_title'
    fill_in_rich_text_area '投稿内容', with: "test_body"
    fill_in "タグ", with: "test_tag"
    attach_file '画像', "#{Rails.root}/app/assets/images/test_post_img.jpg"
    click_on "投稿する"
  end

  def other_post_create(post)
    visit new_post_path
    fill_in "投稿タイトル", with: 'other_title'
    fill_in_rich_text_area '投稿内容', with: "other_body"
    fill_in "タグ", with: "other_tag"
    attach_file '画像', "#{Rails.root}/app/assets/images/other_post_img.jpg"
    click_on "投稿する"
  end
end
