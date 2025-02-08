class BlogPostsController < ApplicationController
  before_action :set_blog_post, only: %i[ show edit update destroy ]
  before_action :authorize_admin!, except: %i[ show index ]
  before_action :authorize_owner!, only: %i[edit update destroy]
  # GET /blog_posts or /blog_posts.json
  def index
    if params[:tag].present?
      @blog_posts = BlogPost.joins(:tags).where(tags: { id: params[:tag] }).order(created_at: :desc)
    else
      @blog_posts = BlogPost.all.order(created_at: :desc)
    end
    @tags = Tag.all # Get all the tags for the filter
  end

  # GET /blog_posts/1 or /blog_posts/1.json
  def show
  end

  # GET /blog_posts/new
  def new
    @blog_post = BlogPost.new
  end

  # GET /blog_posts/1/edit
  def edit
  end

  def my_blogs
    @tags = Tag.all
    @blog_posts = current_admin.blog_posts.order(created_at: :desc)
    render :index
  end

  # POST /blog_posts or /blog_posts.json
  def create
    @blog_post = current_admin.blog_posts.new(blog_post_params)  # Assign admin automatically
    
    if params[:blog_post][:new_tag].present?
      tag = Tag.find_or_create_by(name: params[:blog_post][:new_tag])
      @blog_post.tags << tag unless @blog_post.tags.include?(tag)  # Avoid duplicates
      params[:blog_post][:tag_ids] = @blog_post.tags.map(&:id)  # Ensure tag_ids are passed
    end
    

    respond_to do |format|
      if @blog_post.save
        format.html { redirect_to @blog_post, notice: "Blog post was successfully created." }
        format.json { render :show, status: :created, location: @blog_post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @blog_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blog_posts/1 or /blog_posts/1.json
  def update
    # Handle new tags if provided
    if params[:blog_post][:new_tag].present?
      tag = Tag.find_or_create_by(name: params[:blog_post][:new_tag])
      @blog_post.tags << tag unless @blog_post.tags.include?(tag)
      params[:blog_post][:tag_ids] = @blog_post.tags.map(&:id)
    end
    respond_to do |format|
      if @blog_post.update(blog_post_params)
        format.html { redirect_to @blog_post, notice: "Blog post was successfully updated." }
        format.json { render :show, status: :ok, location: @blog_post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @blog_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blog_posts/1 or /blog_posts/1.json
  def destroy
    @blog_post.destroy!

    respond_to do |format|
      format.html { redirect_to blog_posts_path, status: :see_other, notice: "Blog post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog_post
      @blog_post = BlogPost.friendly.find(params.expect(:id))
    end

    def authorize_owner!
      unless @blog_post.admin == current_admin
        redirect_to blog_posts_path, alert: "You are not authorized to perform this action."
      end
    end

    # Only allow a list of trusted parameters through.
    def blog_post_params
      params.require(:blog_post).permit(:title, :body, :banner_image, tag_ids: [], new_tag: {})
    end
  end    
