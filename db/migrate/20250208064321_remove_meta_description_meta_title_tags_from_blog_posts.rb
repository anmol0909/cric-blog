class RemoveMetaDescriptionMetaTitleTagsFromBlogPosts < ActiveRecord::Migration[8.0]
  def change
    remove_column :blog_posts, :meta_description, :text
    remove_column :blog_posts, :meta_title, :string
    remove_column :blog_posts, :tags, :text
  end
end
