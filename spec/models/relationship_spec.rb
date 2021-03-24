# == Schema Information
#
# Table name: relationships
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  follower_id  :integer
#  following_id :integer
#
# Indexes
#
#  index_relationships_on_follower_id_and_following_id  (follower_id,following_id) UNIQUE
#
require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:relationship) { user.following_relationships.create(following_id: other_user.id) }
  let!(:same_relationship) { user.following_relationships.create(following_id: other_user.id) }

  it "リレーションが有効であること" do
    expect(relationship).to be_valid
  end

  it "follower_idがなければ無効であること" do
    relationship.follower_id = nil
    expect(relationship).to be_invalid
  end
  it "followed_idがなければ無効であること" do
    relationship.following_id = nil
    expect(relationship).to be_invalid
  end

  it "following_idとfollowing_idの組み合わせが一意でない場合、無効であること" do
    expect(same_relationship).to be_invalid
  end
end
