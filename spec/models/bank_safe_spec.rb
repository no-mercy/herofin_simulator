require 'rails_helper'

RSpec.describe BankSafe, type: :model do
  before(:each) do
    @bank_safe = Bank.bank_safe
  end

  it 'checks withdraw! operation behaviour' do
    initial_amount = @bank_safe.available_money
    @bank_safe.withdraw!(50)
    expect(@bank_safe.available_money).to eq(initial_amount - 50)
  end

  it 'checks deposit! operation behaviour' do
    initial_amount = @bank_safe.available_money
    @bank_safe.deposit!(50)
    expect(@bank_safe.available_money).to eq(initial_amount + 50)
  end

  it 'checks banking operation with zero amount behaviour' do
    expect { @bank_safe.withdraw!(0) }.to raise_error('only positive amount is accepted to withdraw')
    expect { @bank_safe.deposit!(0) }.to raise_error('only positive amount is accepted to deposit')
  end

  it 'checks you can not withdraw more than account have' do
    bigger_amount = @bank_safe.available_money + 100
    expect { @bank_safe.withdraw!(bigger_amount) }.to raise_error('not enougth money')
  end
end
