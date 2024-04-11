class Stock < ApplicationRecord
  belongs_to :user

  validates :symbol, presence: true, uniqueness: { scope: :user_id }
  validates :shares, numericality: { greater_than_or_equal_to: 0 }
end
