# == Schema Information
#
# Table name: post_tags
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer
#  tag_id     :integer
#
# Indexes
#
#  index_post_tags_on_post_id             (post_id)
#  index_post_tags_on_post_id_and_tag_id  (post_id,tag_id) UNIQUE
#  index_post_tags_on_tag_id              (tag_id)
#
require 'rails_helper'

RSpec.describe PostTag, type: :model do
  let(:post_tag) { create(:post_tag) }

  it "post_idとtag_idがある場合、有効であること" do
    expect(post_tag).to be_valid
  end

  it "post_idがない場合、無効であること" do
    post_tag.post_id = nil
    expect(post_tag).to be_invalid
  end

  it "tag_idがない場合、無効であること" do
    post_tag.tag_id = nil
    expect(post_tag).to be_invalid
  end
end
