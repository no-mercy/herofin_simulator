# typical banking operations
module BankingOperations
  extend ActiveSupport::Concern

  def withdraw!(amount)
    check_withdraw(amount)
    self.available_money -= amount
    save!
  end

  def deposit!(amount)
    check_deposit(amount)
    self.available_money += amount
    save!
  end

  private

  def check_withdraw(amount)
    raise "banking is disabled for #{self.class}" if banking_disabled?
    raise 'not enougth money' if available_money < amount
    raise 'only positive amount is accepted to withdraw' if amount < 1
  end

  def check_deposit(amount)
    raise "banking is disabled for #{self.class}" if banking_disabled?
    raise 'only positive amount is accepted to deposit' if amount < 1
  end
end
