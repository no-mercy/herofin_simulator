require 'rails_helper'

RSpec.describe HrProfile, type: :model do
  before(:each) do
    user = create(:user)
    @hr_profile = create(:hr_profile, user: user)
  end

  it 'checks hr profile initial state' do
    expect(@hr_profile.state).to eq('hired')
  end

  it 'checks that hr profile cannot be created wihtout user' do
    hr_profile = build(:hr_profile)
    expect(hr_profile).not_to be_valid
    expect(hr_profile.errors.messages[:user]).to eq(['must exist'])
  end

  it 'checks that hr profile can have fired state and it sets fire date' do
    expect(@hr_profile.fire_date).to be_nil
    @hr_profile.fire!
    expect(@hr_profile.fire_date).not_to be_nil
  end
end
