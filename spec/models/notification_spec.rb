# == Schema Information
#
# Table name: notifications
#
#  id         :bigint           not null, primary key
#  action     :string(255)      default(""), not null
#  checked    :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  comment_id :integer
#  post_id    :integer
#  visited_id :integer          not null
#  visitor_id :integer          not null
#
# Indexes
#
#  index_notifications_on_comment_id  (comment_id)
#  index_notifications_on_post_id     (post_id)
#  index_notifications_on_visited_id  (visited_id)
#  index_notifications_on_visitor_id  (visitor_id)
#
require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:notification) { build(:notification, visitor_id: user.id, visited_id: other_user.id, action: 'like') }

  it "visitor_id、visited_id、actionがある場合、有効であること" do
    expect(notification).to be_valid
  end

  it 'visitor_idがなければ無効であること' do
    notification.visitor_id = nil
    expect(notification).to be_invalid
  end

  it 'visited_idがなければ無効であること' do
    notification.visited_id = nil
    expect(notification).to be_invalid
  end

  describe 'action' do
    it 'likeがあれば有効であること' do
      notification.action = 'like'
      expect(notification).to be_valid
    end

    it 'commentがあれば有効であること' do
      notification.action = 'comment'
      expect(notification).to be_valid
    end

    it 'followがあれば有効であること' do
      notification.action = 'follow'
      expect(notification).to be_valid
    end

    it 'actionの文字列が指定外のもの以外なら無効であること' do
      notification.action = 'aaa'
      expect(notification).to be_invalid
    end

    it 'actionがない場合、無効であること' do
      notification.action = nil
      expect(notification).to be_invalid
    end
  end

  describe 'checked' do
    it 'trueがあれば有効であること' do
      notification.checked = 'true'
      expect(notification).to be_valid
    end
    it 'falseがあれば有効であること' do
      notification.checked = 'false'
      expect(notification).to be_valid
    end
    it 'nilの場合、無効であること' do
      notification.checked = nil
      expect(notification).to be_invalid
    end
  end
end
