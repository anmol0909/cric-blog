class Tag < ApplicationRecord
    validates :name, presence: true, uniqueness: { case_sensitive: false }
  
    has_and_belongs_to_many :blog_posts
end
  