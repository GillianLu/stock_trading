class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :stocks, dependent: :destroy

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

  #after_update :send_completed_information_email_to_admin if :information_completed?
  #after_update :send_trader_approval_email, if: -> { trader? && trader_approval? }
  #after_update :send_admin_role_email if :user_admin?

  #setting trader_approval to true after creating new trader or admin
  after_create :set_trader_approval

  #after_create :send_new_account_trader_email if :user_trader?
  #after_create :send_new_account_admin_email if :user_trader?
  # or just one mail 
  
  private

  def information_completed?
    confirmed? && first_name.present? && last_name.present? && address.present? && !trader_approval?
  end

  def user_trader?
    trader?
  end

  def user.admin?
    admin?
  end

  def set_trader_approval
    self.trader_approval = true if user_trader? || user.admin?
    save
  end
  #def send_completed_information_email_to_admin
    #AdminMailer.user_information_completed(self).deliver.now
  #end
  
end
