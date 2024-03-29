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
FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "title-#{n}" }
    sequence(:body) { |n| "body-#{n}" }

    association :user
    after(:create) do |post|
      create_list(:post_tag, 1, post: post, tag: create(:tag))
    end
  end
end
