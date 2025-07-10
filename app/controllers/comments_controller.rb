class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_legal_prompt, only: [:create]
  before_action :set_comment, only: [:destroy]
  
  def create
    @comment = @legal_prompt.comments.build(comment_params)
    @comment.user = current_user
    
    if @comment.save
      redirect_to @legal_prompt, notice: '댓글이 등록되었습니다.'
    else
      redirect_to @legal_prompt, alert: '댓글 등록에 실패했습니다.'
    end
  end
  
  def destroy
    if @comment.user == current_user
      @comment.destroy
      redirect_to @comment.legal_prompt, notice: '댓글이 삭제되었습니다.'
    else
      redirect_to @comment.legal_prompt, alert: '권한이 없습니다.'
    end
  end
  
  private
  
  def set_legal_prompt
    @legal_prompt = LegalPrompt.find(params[:legal_prompt_id])
  end
  
  def set_comment
    @comment = Comment.find(params[:id])
  end
  
  def comment_params
    params.require(:comment).permit(:content)
  end
end