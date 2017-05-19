require 'rails_helper'

RSpec.describe BankingOperationsController, type: :controller do
  it 'checks #transfer_money action' do
    user_one = create(:user)
    user_two = create(:user)
    user_one_old_amount = user_one.account.available_money
    user_two_old_amount = user_two.account.available_money
    post :transfer_money, params: {
      source_user_id: user_one.id,
      target_user_id: user_two.id,
      amount: 100
    }
    expect(response).to be_success
    expect(user_one.account.reload.available_money).to eq(user_one_old_amount - 100)
    expect(user_two.account.reload.available_money).to eq(user_two_old_amount + 100)
  end
end
