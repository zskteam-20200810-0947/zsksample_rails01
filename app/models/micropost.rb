class Micropost < ApplicationRecord
  has_one_attached :avatar
  belongs_to :user
  validates :content, presence: true, length: { maximum: 140 }
end
