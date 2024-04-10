class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  #roles
  #enum role: [:user, :trader, :admin]

  #model validations
  validates :email, presence: true, uniqueness: true
  validates :first_name, format: { with: /\A[A-Za-z]+\z/ , message: "can only contain letters" }
  validates :last_name, format: { with: /\A[A-Za-z]+\z/ , message: "can only contain letters" }
  #validates :address
  validates :balance, numericality: { greater_than_or_equal_to: 0}

  after_update :send_completed_information_email_to_admin if :information_completed?
  
  private
  
  def information_completed?
    first_name.present? && last_name.present? && address.present?
  end

  def send_completed_information_email_to_admin
    AdminMailer.user_information_completed(self).deliver.now
  end
end
