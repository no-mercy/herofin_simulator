require 'rails_helper'

RSpec.describe Operation, type: :model do
  it 'checks that new operation should have prepared state' do
    operation = build(:operation)
    expect(operation.state).to eq('prepared')
  end

  it 'checks operation type transformed to symbol' do
    op_type = 'bank_to_acc'
    operation = build(:operation, operation_type: op_type)
    expect(operation.operation_type).to eq(op_type.to_sym)
  end

  it 'checks that operation validates that amount has size > 0' do
    operation = build(:operation, operation_type: :bank_to_acc, amount: 0)
    expect(operation).not_to be_valid
    expect(operation.errors.messages[:amount]).to eq(['must be greater than 0'])
  end

  it 'checks that operation can have processed state' do
    operation = build(:operation, operation_type: :bank_to_acc)
    operation.accept!
    expect(operation.state).to eq('processed')
  end

  it 'checks that operation can correctly find money source for bank' do
    operation = build(:operation, operation_type: :bank_to_acc)
    expect(operation.money_source).to eq(Bank.bank_safe)
  end

  it 'checks that operation can correctly find money source for company' do
    operation = build(:operation, operation_type: :company_to_acc)
    expect(operation.money_source).to eq(Company::FinancesDpt)
  end

  before(:each) do
    user = create(:user)
    @account = create(:account, user: user)
  end

  it 'checks it can find operations by account' do
    operation = create( :operation, operation_type: :bank_to_acc, recipient_acc_id: @account.id)
    expect(Operation.all_by_account(@account)).to include(operation)
  end

  it 'check that operation can correctly find money source for accounts' do
    operation = build(:operation, operation_type: :acc_to_acc, source_acc_id: @account.id)
    expect(operation.money_source).to eq(@account)
    operation = build(:operation, operation_type: :acc_to_bank, source_acc_id: @account.id)
    expect(operation.money_source).to eq(@account)
  end

  it 'checks that operation can correctly find money destination for account to account operation' do
    user_two = create(:user)
    account_two = create(:account, user: user_two)
    operation = build(
      :operation,
      operation_type: :acc_to_acc,
      source_acc_id: @account.id,
      recipient_acc_id: account_two.id
    )
    expect(operation.money_recipient).to eq(account_two)
  end

  it 'checks that operation can correctly find money destination bank to account operation' do
    operation = build( :operation, operation_type: :bank_to_acc, recipient_acc_id: @account.id)
    expect(operation.money_recipient).to eq(@account)
  end

  it 'checks that operation can correctly find money destination company to account operation' do
    operation = build( :operation, operation_type: :company_to_acc, recipient_acc_id: @account.id)
    expect(operation.money_recipient).to eq(@account)
  end

  it 'checks that operation can correctly find money destination for bank' do
    operation = build( :operation, operation_type: :acc_to_bank)
    expect(operation.money_recipient).to eq(Bank.bank_safe)
  end

  it 'checks operation correctly defines operation type when account is source' do
    operation = build( :operation, operation_type: :acc_to_acc, source_acc_id: @account.id)
    context_type = operation.type_by_context_of(@account)
    expect(context_type).to eq(:withdraw)
  end

  it 'checks operation correctly defines operation type when account is destination' do
    operation = build( :operation, operation_type: :company_to_acc, recipient_acc_id: @account.id)
    context_type = operation.type_by_context_of(@account)
    expect(context_type).to eq(:deposit)
  end
end
