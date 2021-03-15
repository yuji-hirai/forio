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
class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_rich_text :body

  validates :title,
            presence: true,
            length: { maximum: 50 }
  validates :body,
            presence: true,
            length: { maximum: 1000 }

  def save_tags(tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags

    # 古いタグを削除
    old_tags.each do |old_name|
      self.tags.delete(Tag.find_by(name: old_name))
    end

    # 新しいタグを追加
    new_tags.each do |new_name|
      post_tag = Tag.find_or_create_by(name: new_name)
      self.tags << post_tag
    end
  end

  # 検索メソッド、タイトルと内容をあいまいに検索する
  # def self.posts_search(search)
  #   Post.where(['title LIKE ? OR body LIKE ?', "%#{search}%", "%#{search}%"])
  # end
end
