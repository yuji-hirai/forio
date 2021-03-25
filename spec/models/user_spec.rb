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
#  provider               :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  uid                    :string(255)
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

  it "名前、メール、パスワードがある場合、有効であること" do
    expect(user).to be_valid
  end

  describe "名前" do
    let!(:same_name_user) { create(:user, name: "same_name") }

    it "名前がない場合、無効であること" do
      user.name = nil
      expect(user).to be_invalid
      expect(user.errors[:name]).to include("を入力してください")
    end

    it "名前に一意性がない場合、無効であること" do
      user.name = "same_name"
      expect(user).to be_invalid
      expect(user.errors[:name]).to include("はすでに存在します")
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
        expect(user.errors[:name]).to include("は50文字以内で入力してください")
      end
    end
  end

  describe "メールアドレス" do
    it "メールアドレスがない場合、無効であること" do
      user.email = nil
      user.valid?
      expect(user.errors[:email]).to include("を入力してください")
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
        expect(user.errors[:email]).to include("は255文字以内で入力してください")
      end
    end
  end

  describe "パスワード" do
    it "パスワードがない場合、無効であること" do
      user = build(:user, password: nil)
      expect(user).to be_invalid
      expect(user.errors[:password]).to include("を入力してください")
    end

    context "6文字以上の場合" do
      it "有効であること" do
        user.password = "1" * 6
        user.password_confirmation = "1" * 6
        expect(user).to be_valid
      end
    end

    context "5文字以下の場合" do
      it "無効であること" do
        user.password = "1" * 5
        user.password_confirmation = "1" * 5
        expect(user).to be_invalid
        expect(user.errors[:password]).to include("は6文字以上で入力してください")
      end
    end

    context "128文字以下の場合" do
      it "有効であること" do
        user.password = "1" * 128
        user.password_confirmation = "1" * 128
        expect(user).to be_valid
      end
    end

    context "129文字以上の場合" do
      it "無効であること" do
        user.password = "1" * 129
        user.password_confirmation = "1" * 129
        expect(user).to be_invalid
        expect(user.errors[:password]).to include("は128文字以内で入力してください")
      end
    end

    context "passwordとpassword_confirmationが異なる場合" do
      it "無効であること" do
        user.password = "TEST_PASSWORD"
        user.password_confirmation = "OTHER_TEST_PASSWORD"
        expect(user).to be_invalid
      end
    end
  end

  describe "followとfollower" do
    let(:other_user) { create(:user) }

    before { user.follow(other_user) }

    it "フォローが有効になること" do
      expect(user.following?(other_user)).to be_valid
    end

    it "フォロワーが有効になること" do
      expect(other_user.followers.include?(user)).to be_truthy
    end

    it "unfollowした場合、フォローが無効になること" do
      user.unfollow(other_user)
      expect(user.following?(other_user)).to be_falsy
    end
  end
end
