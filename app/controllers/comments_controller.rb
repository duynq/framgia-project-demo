class CommentsController < ApplicationController
  def create
  	@comment = Comment.new(comment_params)
  	flash.now[:danger] = "Comment invalid" unless @comment.save
  	respond_to do |format|
      # format.html { redirect_to request.referer }
      format.js
    end
  end

  def destroy
    @id = params[:id]
    Comment.find_by(id: @id).destroy
    flash.now[:success] = "Comment deleted"
    respond_to do |format|
      # format.html { redirect_to request.referer }
      format.js
    end
  end

  def edit
    @comment = Comment.find_by(id: params[:id])
    respond_to do |format|
      format.js
    end
    
  end

  def update
    @comment = Comment.find_by(id: params[:id])
    if @comment.update_attributes(comment_params)
      flash.now[:success] = "Comment updated"
    else
      flash.now[:danger] = "Comment invalid"
    end

    respond_to do |format|
      # format.html { redirect_to @comment.entry }
      format.js
    end
  end  


  private
  def comment_params
    params.require(:comment).permit(:content, :user_id, :entry_id)
  end
end
