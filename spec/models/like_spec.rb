# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer
#  user_id    :integer
#
require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'いいね' do
    let(:like) { create(:like) }

    it 'user_idとpost_idがある場合、有効であること' do
      expect(like).to be_valid
    end

    it 'user_idがない場合、無効であること' do
      like.user_id = nil
      expect(like).to be_invalid
    end

    it 'post_idがない場合、無効であること' do
      like.post_id = nil
      expect(like).to be_invalid
    end

    it 'post_idとuser_idの組み合わせが一意でない場合、無効であること' do
      another_like = build(:like, user_id: like.user_id, post_id: like.post_id)
      expect(another_like).to be_invalid
    end
  end
end
