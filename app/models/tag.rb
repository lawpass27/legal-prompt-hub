class Tag < ApplicationRecord
  has_and_belongs_to_many :legal_prompts
  
  validates :name, presence: true, uniqueness: true
  
  before_save :normalize_name
  
  private
  
  def normalize_name
    self.name = name.downcase.strip.gsub(/\s+/, '-')
  end
end
