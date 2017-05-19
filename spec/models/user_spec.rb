require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = create(:user)
  end

  it 'checks that new user should get birthday' do
    expect(@user.birthday).not_to be_nil
  end

  it 'checks that new user should have newborn state' do
    expect(@user.state).to eq('newborn')
  end

  it 'checks user name presence validation' do
    user = build(:user, name: nil)
    expect(user).not_to be_valid
    expect(user.errors.messages[:name]).to eq(["can't be blank"])
  end

  it 'checks that new user get account from bank' do
    expect(@user.account).not_to be_nil
  end

  it 'checks that user should get to work after become adult' do
    @user.celebrate_adulthood!
    expect(@user.state).to eq('worker')
  end

  it 'checks that user should not have death_date till death' do
    expect(@user.time_of_death).to be_nil
    @user.celebrate_adulthood!
    expect(@user.time_of_death).to be_nil
  end

  it 'checks that user should get death_date after death' do
    @user.celebrate_adulthood!
    @user.death!
    expect(@user.time_of_death).not_to be_nil
  end

  it 'checks that users is in all_alive scope, when they are alive' do
    expect(User.all_alive).not_to be_empty
  end

  it 'checks that user is not in alive lists, when it is dead' do
    @user.celebrate_adulthood!
    @user.death!
    expect(User.all_alive).to be_empty
  end

  it 'checks that newborn users should not appear in ready-to-work list' do
    expect(User.old_enough_to_work).to be_empty
  end

  it 'checks that 18+ minute users should appear in ready-to-work list' do
    @user.update_attribute(:birthday, 18.minutes.ago)
    expect(User.old_enough_to_work).not_to be_empty
  end

  it 'checks that users with life less 5 hours should not appear in read-to-death list' do
    @user.update_attribute(:birthday, 299.minutes.ago)
    expect(User.old_enough_to_die).to be_empty
  end

  it 'checks that users with life 5+ hours should appear in read-to-death list' do
    @user.update_attribute(:birthday, 300.minutes.ago)
    expect(User.old_enough_to_die).not_to be_empty
  end

  it 'checks that grow_up_childs process grows up 18+ users' do
    @user.update_attribute(:birthday, 18.minutes.ago)
    User.grow_up_childs!
    expect(@user.reload.state).to eq('worker')
  end

  it 'checks that grow_up_childs process is not toching 17- users' do
    @user.update_attribute(:birthday, 17.minutes.ago)
    User.grow_up_childs!
    expect(@user.reload.state).not_to eq('worker')
  end

  it 'checks that kill_old_users process kills 300+ users' do
    @user.celebrate_adulthood!
    @user.update_attribute(:birthday, 300.minutes.ago)
    User.kill_old_users!
    expect(@user.reload.state).to eq('dead')
  end

  it 'checks that kill_old_users process is not killing 299- users' do
    @user.celebrate_adulthood!
    @user.update_attribute(:birthday, 299.minutes.ago)
    User.kill_old_users!
    expect(@user.reload.state).not_to eq('dead')
  end
end
