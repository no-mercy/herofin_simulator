require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before(:each) do
    @user = create(:user)
  end

  it 'checks #index action' do
    get :index
    expect(response).to be_success
    expect(response).to render_template('users/index')
    expect(assigns(:users)).to include(@user)
  end

  it 'checks #show action' do
    user_two = create(:user, name: 'Joe Foe')
    get :show, params: { id: @user.id }
    expect(response).to be_success
    expect(response).to render_template('users/show')
    expect(assigns(:user)).to eq(@user)
    expect(assigns(:operations)).not_to be_nil
    expect(assigns(:money_transfer_target_users)).to include(user_two)
  end

  it 'checks #create action with valid name passed' do
    new_user_name = 'July Does'
    post :create, params: { name: new_user_name }
    expect(response).to be_success
    expect(User.find_by(name: new_user_name)).not_to be_nil
  end

  it 'checks #create action without valid name passed' do
    post :create
    expect(response).not_to be_success
  end

  it 'checks #destroy action' do
    @user.celebrate_adulthood!
    expect(@user.dead?).to be false
    post :destroy, params: { id: @user.id }
    expect(response).to be_success
    expect(@user.reload.dead?).to be true
  end
end
