class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :legal_prompt
  
  validates :content, presence: true, length: { minimum: 1, maximum: 500 }
  
  scope :recent, -> { order(created_at: :desc) }
end
