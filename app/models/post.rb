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
#  user_id    :integer
#
class Post < ApplicationRecord

  belongs_to :user

  validates :title,
            presence: true,
            length: { maximum: 50 }
  validates :body,
            presence: true,
            length: { maximum: 10000 }

end
