class BlogPost < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_rich_text :body
  has_one_attached :banner_image
  belongs_to :admin
  has_and_belongs_to_many :tags
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true
end
