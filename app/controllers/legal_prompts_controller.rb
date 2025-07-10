class LegalPromptsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_legal_prompt, only: [:show, :edit, :update, :destroy]
  before_action :check_owner, only: [:edit, :update, :destroy]

  def index
    if params[:tag].present?
      @legal_prompts = LegalPrompt.tagged_with(params[:tag]).includes(:user, :tags).recent
      @current_tag = params[:tag]
    else
      @legal_prompts = LegalPrompt.includes(:user, :tags).recent
    end
  end

  def show
    @comments = @legal_prompt.comments.includes(:user).recent
    @comment = @legal_prompt.comments.build if user_signed_in?
  end

  def new
    @legal_prompt = current_user.legal_prompts.build
  end

  def create
    @legal_prompt = current_user.legal_prompts.build(legal_prompt_params)
    
    if @legal_prompt.save
      redirect_to @legal_prompt, notice: '프롬프트가 성공적으로 생성되었습니다.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @legal_prompt.update(legal_prompt_params)
      redirect_to @legal_prompt, notice: '프롬프트가 성공적으로 업데이트되었습니다.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @legal_prompt.destroy
    redirect_to legal_prompts_url, notice: '프롬프트가 성공적으로 삭제되었습니다.'
  end

  private

  def set_legal_prompt
    @legal_prompt = LegalPrompt.find(params[:id])
  end

  def legal_prompt_params
    params.require(:legal_prompt).permit(:title, :category, :content, :description, :tag_list)
  end

  def check_owner
    redirect_to legal_prompts_path, alert: '권한이 없습니다.' unless @legal_prompt.user == current_user
  end
end