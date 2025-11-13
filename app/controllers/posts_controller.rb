class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :comments_drawer]
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.includes(author: { avatar_attachment: :blob }).order(created_at: :desc)
    @post = Post.new
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.prepend("posts", partial: "posts/post", locals: { post: @post })
        end
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("post_form", partial: "posts/form", locals: { post: @post }), status: :unprocessable_entity
        end
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@post) }
      format.html { redirect_to posts_path, notice: "Post was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # GET /posts/:id/comments_drawer
  def comments_drawer
    @post = Post.find(params[:id])
    @comments = @post.comments.includes(author: { avatar_attachment: :blob }).order(created_at: :asc) if @post.respond_to?(:comments)
    render layout: false
  end

  def toggle_like
    @post = Post.find(params[:id])
    # Post.last.likes.create(user_id: 1)
    # @like = current_user.likes.build(post_id: params[:id])
    @like = @post.likes.find_by(user: current_user)

    if @like
      # If the user already liked it, unlike it
      @like.destroy
    else
      # If the user hasn't liked it, like it
      @post.likes.create(user: current_user)
    end

    respond_to do |format|
      format.html { render partial: "posts/post", locals: { post: @post }, layout: false } # Unpoly expects HTML fragment
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.expect(post: [ :author_id, :body ])
    end
end
