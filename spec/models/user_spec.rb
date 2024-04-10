require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'validates presence of email' do
      user = User.new(email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end
    
    it "validates format of first_name" do
      user = FactoryBot.build(:user, first_name: "123")
      expect(user).not_to be_valid
      expect(user.errors[:first_name]).to include("can only contain letters")
    end

    it "validates format of last_name" do
      user = FactoryBot.build(:user, last_name: "123")
      expect(user).not_to be_valid
      expect(user.errors[:last_name]).to include("can only contain letters")
    end

    it 'user balance not valid' do
      user = User.new(email: 'example@example.com', password: 'password', balance: -100)
      expect(user).not_to be_valid
    end
  end
  
  describe 'callbacks' do
  end
end
