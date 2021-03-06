# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  introduction           :text(65535)
#  name                   :string(255)
#  password               :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it "名前、メールがある場合、有効であること" do
    user = build(:user)
    expect(user).to be_valid
  end

  describe "名前" do
    it "名前がない場合、無効であること" do
      user = build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")
    end

    context "名前が50文字以下の場合" do
      it "有効であること" do
        user.name = "1" * 50
        expect(user).to be_valid
      end
    end

    context "名前が51文字以上の場合" do
      it "無効であること" do
        user.name = "1" * 51
        expect(user).to be_invalid
      end
    end
  end

  describe "メールアドレス" do
    it "メールアドレスがない場合、無効であること" do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "小文字大文字に限らず一意性でない場合、無効であること" do
      duplicate_user = user.dup
      duplicate_user.email = user.email.upcase
      user.save!
      expect(duplicate_user).to be_invalid
    end

    it "大文字と小文字を混同して登録したアドレスは、小文字処理されていること" do
      user.email = "Test@ExAMPle.Com"
      user.save!
      expect(user.reload.email).to eq "test@example.com"
    end

    it "正しいフォーマットでない場合、無効であること" do
      emails = %w(user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com foo@bar..com)
      emails.each do |invalid_emails|
        expect(build(:user, email: invalid_emails)).to be_invalid
      end
    end

    context "255文字以下の場合" do
      it "有効であること" do
        user.email = "1" * 243 + "@example.com"
        expect(user).to be_valid
      end
    end

    context "256文字以上の場合" do
      it "無効であること" do
        user.email = "1" * 244 + "@example.com"
        expect(user).to be_invalid
      end
    end
  end
end
