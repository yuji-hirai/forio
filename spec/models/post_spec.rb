# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text(65535)
#  image      :string(255)
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

RSpec.describe Post, type: :model do
  let(:post) { create(:post) }
  let!(:same_title_post) { create(:post, title: "same_title") }

  it "タイトル、本文、user_idがある場合、有効であること" do
    expect(post).to be_valid
  end

  it "user_idがない場合、無効であること" do
    post.user_id = nil
    expect(post).to be_invalid
  end

  describe "タイトル" do
    it "タイトルがない場合、無効であること" do
      post.title = nil
      expect(post).to be_invalid
      expect(post.errors[:title]).to include("を入力してください")
    end

    context "タイトルが60文字以下の場合" do
      it "有効であること" do
        post.title = "1" * 60
        expect(post).to be_valid
      end
    end

    context "タイトルが61文字以上の場合" do
      it "無効であること" do
        post.title = "1" * 61
        expect(post).to be_invalid
      end
    end
  end

  describe "本文" do
    it "本文がない場合、無効であること" do
      post.body = nil
      expect(post).to be_invalid
      expect(post.errors[:body]).to include("を入力してください")
    end

    context "本文が2000文字以下の場合" do
      it "有効であること" do
        post.body = "1" * 2000
        expect(post).to be_invalid
      end
    end

    context "本文が2001文字以上の場合" do
      it "無効であること" do
        post.body = "1" * 2001
        expect(post).to be_invalid
      end
    end
  end
end
