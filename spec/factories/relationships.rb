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
FactoryBot.define do
  factory :relationship do
  end
end
