class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_comment, only: %i[ show edit update destroy ]

  def show
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = Comment.new(comment_params)
    @comment.author = current_user
    @comment.post = @post

    if @comment.save
      @comments = @post.comments.includes(:author).order(created_at: :asc)
      render 'posts/comments_drawer', layout: false, status: :ok
    else
      @comments = @post.comments.includes(:author).order(created_at: :asc)
      render 'posts/comments_drawer', layout: false, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: "Comment was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy!

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@comment) }
      format.html { redirect_to posts_path, notice: "Comment was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:text)
    end
end
