class UsersController < ApplicationController
  def index
    @users = User.all.order(birthday: :desc)
  end

  def show
    @user = User.find(params[:id])
    @operations = Bank.generate_opeartions_report(@user)
    @money_transfer_target_users = User.all_alive.where.not(id: @user.id)
  end

  def create
    return head 400 if safe_username.blank?
    @user = User.create!(safe_username)
  end

  def destroy
    User.find(params[:id]).death!
  end

  private

  def safe_username
    params.permit(:name)
  end
end
