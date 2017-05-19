class BankingOperationsController < ApplicationController
  def transfer_money
    Bank.transfer_money(*money_transfer_params)
  end

  private

  def money_transfer_params
    source_user = User.find(params[:source_user_id])
    target_user = User.find(params[:target_user_id])
    amount = Integer(params[:amount])
    [source_user, target_user, amount, params[:description]]
  end
end
