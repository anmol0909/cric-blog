class Tag < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, uniqueness: true

  has_and_belongs_to_many :blog_posts
end
