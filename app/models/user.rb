class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :stocks, dependent: :destroy
  has_many :transactions, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  #roles
  enum role: [:user, :trader, :admin]

  scope :user, -> { where(role: 'user')}
  scope :trader, -> { where(role: 'trader')}
  scope :admin, -> { where(role: 'admin')}

  #model validations
  validates :email, presence: true, uniqueness: true
  validates :first_name, format: { with: /\A[A-Za-z]+\z/ , message: "can only contain letters" }, allow_blank: true
  validates :last_name, format: { with: /\A[A-Za-z]+\z/ , message: "can only contain letters" }, allow_blank: true
  #validates :address
  validates :balance, numericality: { greater_than_or_equal_to: 0}
  
end
