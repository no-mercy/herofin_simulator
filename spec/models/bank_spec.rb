require 'rails_helper'

RSpec.describe Bank, type: :model do
  before(:each) do
    @user = create(:user)
    @account = @user.account
  end

  it 'checks Bank respond to available_money' do
    expect(Bank).to respond_to(:available_money)
  end

  it 'checks Bank has bank_safe' do
    expect(Bank.bank_safe).to be_an_instance_of(BankSafe)
  end

  it 'checks Bank can create account with money for user' do
    allow_any_instance_of(User).to receive(:inform_bank_about_newborn)
    user = create(:user)
    expect(user.account).to be_nil
    Bank.add_account_for_newborn(user)
    expect(user.reload.account).not_to be_nil
    expect(user.account.available_money).to be > 0
  end

  it 'checks Bank can take all money back when user is dead' do
    user = create(:user, state: :dead)
    account = user.account
    expect(account.disabled?).not_to be true
    expect(account.available_money).to be > 0
    Bank.inform_about_death(user)
    expect(account.reload.disabled?).to be true
    expect(account.available_money).to eq(0)
  end

  it 'checks Bank can not take all money back when user is not dead' do
    expect(@user.dead?).to be false
    expect(@account.disabled?).not_to be true
    expect(@account.available_money).to be > 0
    Bank.inform_about_death(@user)
    expect(@account.reload.disabled?).to be false
    expect(@account.available_money).not_to eq(0)
  end

  it 'checks money transfer from Bank to account' do
    old_amount = @account.available_money
    Bank.transfer_money(Bank, @user, 100)
    expect(@account.reload.available_money).to eq(old_amount + 100)
  end

  it 'checks money transfer from account to Bank' do
    old_amount = @account.available_money
    old_bank_amount = Bank.available_money
    Bank.transfer_money(@user, Bank, 100)
    expect(@account.reload.available_money).to eq(old_amount - 100)
    expect(Bank.available_money).to eq(old_bank_amount + 100)
  end

  it 'checks money transfer from Company to account' do
    old_amount = @account.available_money
    Bank.transfer_money(Company::FinancesDpt, @user, 100)
    expect(@account.reload.available_money).to eq(old_amount + 100)
  end

  it 'checks money transfer from account to another account' do
    user_two = create(:user)
    account_two = user_two.account
    old_amount_of_user = @account.available_money
    old_amount_of_user_two = account_two.available_money
    Bank.transfer_money(@user, user_two, 100)
    expect(@account.reload.available_money).to eq(old_amount_of_user - 100)
    expect(account_two.reload.available_money).to eq(old_amount_of_user_two + 100)
  end

  it 'can generate finance operations report for user' do
    report = Bank.generate_opeartions_report(@user)
    expect(report.length).to eq(1)
    expect(report.first.type).to eq(:deposit)
    Bank.transfer_money(@user, Bank, 100)
    report = Bank.generate_opeartions_report(@user)
    expect(report.length).to eq(2)
    expect(report.first.type).to eq(:withdraw)
  end

  it 'check operations report values' do
    report = Bank.generate_opeartions_report(@user).first
    expect(report.name).to be_a(String)
    expect(report.type).to be_a(Symbol)
    expect(report.amount).to be_a(Integer)
    expect(report.state).to be_a(String)
  end
end
