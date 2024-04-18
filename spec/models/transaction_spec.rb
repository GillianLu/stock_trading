require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe 'validations' do
    context 'when creating a buy transaction' do
      it 'should be valid with sufficient balance' do
        transaction = FactoryBot.build(:transaction, action: 'buy', user: user, total_amount: 100)
        expect(transaction).to be_valid
      end

      it 'should be invalid with insufficient balance' do
        transaction = FactoryBot.build(:transaction, action: 'buy', user: user, total_amount: 2000)
        expect(transaction).not_to be_valid
        expect(transaction.errors[:base]).to include('Not enough balance')
      end
    end

    context 'when creating a sell transaction' do
      it 'should be valid with sufficient shares' do
        stock = FactoryBot.create(:stock, user: user, shares: 10)
        transaction = FactoryBot.build(:transaction, action: 'sell', user: user, number_of_shares: 5, stock_symbol: stock.symbol)
        expect(transaction).to be_valid
      end

      it 'should be invalid with insufficient shares' do
        stock = FactoryBot.create(:stock, user: user, shares: 10)
        transaction = FactoryBot.build(:transaction, action: 'sell', user: user, number_of_shares: 15, stock_symbol: stock.symbol)
        expect(transaction).not_to be_valid
        expect(transaction.errors[:base]).to include('Not enough shares')
      end
    end
  end
end