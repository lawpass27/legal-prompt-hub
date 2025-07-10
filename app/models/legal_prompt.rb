class LegalPrompt < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :tags
  has_many :comments, dependent: :destroy
  
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
  
  def tag_list=(names)
    self.tags = names.split(',').map do |n|
      Tag.where(name: n.strip.downcase.gsub(/\s+/, '-')).first_or_create!
    end.uniq
  end
  
  def tag_list
    tags.map(&:name).join(', ')
  end
  
  scope :tagged_with, ->(name) {
    joins(:tags).where(tags: { name: name })
  }
end
