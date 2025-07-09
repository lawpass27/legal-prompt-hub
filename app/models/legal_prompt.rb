class LegalPrompt < ApplicationRecord
  belongs_to :user
  
  enum :category, {
    party_analysis: 0,      # 당사자정보분석
    fact_organizing: 1,     # 사실관계정리
    evidence_linking: 2,    # 증거연결
    keyword_extraction: 3,  # 검색어추출
    law_extraction: 4,      # 관련법령추출
    legal_principles: 5,    # 관련법리추출
    case_search: 6          # 유사판례검색
  }
  
  validates :title, presence: true, length: { maximum: 255 }
  validates :category, presence: true
  validates :content, presence: true
  
  scope :recent, -> { order(created_at: :desc) }
  
  def category_korean
    I18n.t("legal_prompt.categories.#{category}")
  end
end
