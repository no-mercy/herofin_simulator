# Personal money account
class Account < ApplicationRecord
  include BankingOperations

  belongs_to :user

  state_machine initial: :enabled do
    before_transition enabled: :disabled, do: :check_user_is_dead

    event :disable do
      transition enabled: :disabled
    end
  end

  def banking_disabled?
    disabled? # BankingOperations concern related
  end

  private

  def check_user_is_dead
    raise 'cannot be disabled if user is alive' unless user.dead?
  end
end
