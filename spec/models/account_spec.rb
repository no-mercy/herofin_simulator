require 'rails_helper'

RSpec.describe Account, type: :model do
  before(:each) do
    @account = build(:account)
  end

  it 'checks that account has enabled initial state' do
    expect(@account.state).to eq 'enabled'
  end

  it 'checks that account cannot be created wihtout user' do
    expect(@account).not_to be_valid
    expect(@account.errors.messages[:user]).to eq(['must exist'])
  end

  it 'checks that user presence is validated' do
    expect(@account).not_to be_valid
    expect(@account.errors.messages[:user]).to eq(['must exist'])
  end

  it 'checks that account cannot be sewitched to disabled state when user is alive' do
    user = create(:user)
    account = create(:account, user: user)
    expect(user.dead?).not_to be true
    expect { account.disable! }.to raise_error('cannot be disabled if user is alive')
  end

  it 'checks that account can be switched to disabled if user is dead' do
    user = create(:user, state: :dead)
    account = create(:account, user: user)
    expect(user.dead?).to be true
    account.disable!
    expect(account.state).to eq 'disabled'
  end
end
