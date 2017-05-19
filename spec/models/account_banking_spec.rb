require 'rails_helper'

RSpec.describe Account, type: :model do
  before(:each) do
    user = create(:user)
    @account = create(:account, user: user)
  end

  it 'checks withdraw! operation behaviour' do
    initial_amount = @account.available_money
    @account.withdraw!(50)
    expect(@account.available_money).to eq(initial_amount - 50)
  end

  it 'checks deposit! operation behaviour' do
    initial_amount = @account.available_money
    @account.deposit!(50)
    expect(@account.available_money).to eq(initial_amount + 50)
  end

  it 'checks banking operation with zero amount behaviour' do
    expect { @account.withdraw!(0) }.to raise_error('only positive amount is accepted to withdraw')
    expect { @account.deposit!(0) }.to raise_error('only positive amount is accepted to deposit')
  end

  it 'checks banking operation when account is disabled' do
    user = create(:user, state: :dead)
    account = create(:account, user: user)
    account.disable!
    expect { account.withdraw!(10) }.to raise_error('banking is disabled for Account')
    expect { account.deposit!(10) }.to raise_error('banking is disabled for Account')
  end

  it 'checks you can not withdraw more than account have' do
    bigger_amount = @account.available_money + 100
    expect { @account.withdraw!(bigger_amount) }.to raise_error('not enougth money')
  end
end
