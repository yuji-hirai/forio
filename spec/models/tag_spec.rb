# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tags_on_name  (name) UNIQUE
#
require 'rails_helper'

RSpec.describe Tag, type: :model do
  let(:tag) { create(:tag) }

  describe "name" do
    it "タグ名がある場合、有効であること" do
      expect(tag).to be_valid
    end

    it "タグ名がない場合、無効であること" do
      tag.name = nil
      expect(tag).to be_invalid
      expect(tag.errors[:name]).to include("を入力してください")
    end

    context "タグ名が50文字以下の場合" do
      it "有効であること" do
        tag.name = "1" * 50
        expect(tag).to be_valid
      end
    end

    context "タグ名が51文字以上の場合" do
      it "無効であること" do
        tag.name = "1" * 51
        expect(tag).to be_invalid
        expect(tag.errors[:name]).to include("は50文字以内で入力してください")
      end
    end
  end
end
