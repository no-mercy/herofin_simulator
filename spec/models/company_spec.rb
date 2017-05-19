require 'rails_helper'

RSpec.describe Company, type: :model do
  before(:each) do
    @user = create(:user, state: :adult)
  end

  it 'checks Company can hire adult user' do
    expect(Company::HumanResourcesDpt.all_active_workers).not_to include(@user)
    Company.ask_for_job(@user)
    expect(@user.state).to eq('worker')
    expect(Company::HumanResourcesDpt.all_active_workers).to include(@user)
  end

  it 'checks Company can not hire child' do
    @user.update_attribute(:state, :newborn)
    Company.ask_for_job(@user)
    expect(Company::HumanResourcesDpt.all_active_workers).not_to include(@user)
  end

  it 'checks Company can fire dead user' do
    Company.ask_for_job(@user)
    expect(Company::HumanResourcesDpt.all_active_workers).to include(@user)
    @user.update_attribute(:state, :dead)
    Company.inform_about_death(@user)
    expect(Company::HumanResourcesDpt.all_active_workers).not_to include(@user)
  end

  it 'checks Company can not fire alive user' do
    Company.ask_for_job(@user)
    expect(Company::HumanResourcesDpt.all_active_workers).to include(@user)
    Company.inform_about_death(@user)
    expect(Company::HumanResourcesDpt.all_active_workers).to include(@user)
  end

  it 'checks Company creates hr profile for user' do
    expect(HrProfile.find_by(user_id: @user.id)).to be_nil
    Company.ask_for_job(@user)
    expect(HrProfile.find_by(user_id: @user.id)).not_to be_nil
  end

  it 'checks Company creates finance profile for user' do
    expect(FinanceProfile.find_by(user_id: @user.id)).to be_nil
    Company.ask_for_job(@user)
    expect(FinanceProfile.find_by(user_id: @user.id)).not_to be_nil
  end

  it 'checks finance department pays salary to workers' do
    Company.ask_for_job(@user)
    finance_profile = FinanceProfile.find_by(user_id: @user.id)
    old_amount = @user.account.available_money
    finance_profile.update_attribute(:last_paid_time, 6.minutes.ago)
    Company::FinancesDpt.pay_salary_to_workers
    expect(@user.account.reload.available_money).to be > old_amount
  end

  it 'checks that Company pays last salary to workers after their death' do
    Company.ask_for_job(@user)
    finance_profile = FinanceProfile.find_by(user_id: @user.id)
    old_amount = @user.account.available_money
    finance_profile.update_attribute(:last_paid_time, 6.minutes.ago)
    @user.update_attribute(:state, :dead)
    Company.inform_about_death(@user)
    expect(@user.account.reload.available_money).to be > old_amount
  end

  it 'checks that finance department answers to withdraw' do
    expect(Company::FinancesDpt).to respond_to(:withdraw!)
  end
end
