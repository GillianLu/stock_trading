require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    describe 'GET #index' do
        context 'when user is admin' do
            it 'returns http success' do
                admin_user = FactoryBot.create(:user, :admin)
                sign_in admin_user

                get :index
                expect(response).to have_http_status(:success)
            end
        end
        
        context 'when user is not admin' do
            it 'returns http failure - trader' do
                trader_user = FactoryBot.create(:user, :trader)
                sign_in trader_user
                
                get :index
                expect(response).to have_http_status(:unauthorized)
            end

            it 'returns http failure - user' do
                user_user = FactoryBot.create(:user, :user)
                sign_in user_user
                
                get :index
                expect(response).to have_http_status(:unauthorized)
            end
        end
    end
end
