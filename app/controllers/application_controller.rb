class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :bank_safe_status

  private

  def bank_safe_status
    @money_in_bank = Bank.available_money
  end
end
