# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { create(:comment) }

  it "user_id、post_id、contentがある場合、有効であること" do
    expect(comment).to be_valid
  end

  it 'user_idがない場合、無効であること' do
    comment = build(:comment, user_id: nil)
    expect(comment).to be_invalid
  end

  it 'post_idがない場合、無効であること' do
    comment = build(:comment, post_id: nil)
    expect(comment).to be_invalid
  end

  describe "content" do
    it "contentがない場合、無効であること" do
      comment = build(:comment, content: nil)
      expect(comment).to be_invalid
      expect(comment.errors[:content]).to include("を入力してください")
    end

    context "contentが1000文字以下の場合" do
      it "有効であること" do
        comment.content = "1" * 1000
        expect(comment).to be_valid
      end
    end

    context "contentが1001文字以上の場合" do
      it "無効であること" do
        comment.content = "1" * 1001
        expect(comment).to be_invalid
        expect(comment.errors[:content]).to include("は1000文字以内で入力してください")
      end
    end
  end
end
