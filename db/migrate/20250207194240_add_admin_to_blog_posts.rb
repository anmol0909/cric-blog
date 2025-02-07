class AddAdminToBlogPosts < ActiveRecord::Migration[8.0]
  def change
    add_reference :blog_posts, :admin, null: true, foreign_key: true
  end
end
