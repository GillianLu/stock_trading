require 'rails_helper'

RSpec.describe Stock, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe 'validations' do
    it 'should be valid with valid attributes' do
      stock = FactoryBot.build(:stock, user: user)
      expect(stock).to be_valid
    end

    it 'should be invalid without a symbol' do
      stock = FactoryBot.build(:stock, user: user, symbol: nil)
      expect(stock).not_to be_valid
      expect(stock.errors[:symbol]).to include("can't be blank")
    end

    it 'should be invalid without a unique symbol for the same user' do
      existing_stock = FactoryBot.create(:stock, user: user)
      stock = FactoryBot.build(:stock, user: user, symbol: existing_stock.symbol)
      expect(stock).not_to be_valid
      expect(stock.errors[:symbol]).to include("has already been taken")
    end

    it 'should be valid with the same symbol for different users' do
      existing_stock = FactoryBot.create(:stock)
      stock = FactoryBot.build(:stock, user: user, symbol: existing_stock.symbol)
      expect(stock).to be_valid
    end

    it 'should be valid with non-negative shares' do
      stock = FactoryBot.build(:stock, user: user, shares: 10)
      expect(stock).to be_valid
    end

    it 'should be invalid with negative shares' do
      stock = FactoryBot.build(:stock, user: user, shares: -5)
      expect(stock).not_to be_valid
      expect(stock.errors[:shares]).to include("must be greater than or equal to 0")
    end
  end
end