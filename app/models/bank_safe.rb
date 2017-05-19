# Central money storage
class BankSafe < ApplicationRecord
  include BankingOperations

  def banking_disabled?
    false # BankingOperations concern related
  end
end
