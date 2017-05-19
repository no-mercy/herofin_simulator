require 'rails_helper'

RSpec.describe FinanceProfile, type: :model do
  before(:each) do
    user = create(:user)
    @finance_profile = create(:finance_profile, user: user)
  end

  it 'checks that finance profile cannot be created wihtout user' do
    finance_profile = build(:finance_profile)
    expect(finance_profile).not_to be_valid
    expect(finance_profile.errors.messages[:user]).to eq(['must exist'])
  end

  it 'checks that finance profile updates last paid time on salary payment notificaiton' do
    expect(@finance_profile.last_paid_time).to be_nil
    @finance_profile.salary_paid!
    expect(@finance_profile.last_paid_time).not_to be_nil
  end

  it 'checks unpaid periods calculation' do
    @finance_profile.update_attribute(:last_paid_time, 10.minutes.ago)
    expect(@finance_profile.unpaid_periods).to be_within(0.1).of(2)
  end

  it 'checks salary time calculation' do
    @finance_profile.update_attribute(:last_paid_time, 1.minute.ago)
    expect(@finance_profile.salary_time_has_come?).not_to be true
    @finance_profile.update_attribute(:last_paid_time, 5.minutes.ago)
    expect(@finance_profile.salary_time_has_come?).to be true
  end
end
