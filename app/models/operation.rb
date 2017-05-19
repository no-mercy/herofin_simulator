# Saves all money transfer events
class Operation < ApplicationRecord
  validates :operation_type,
            inclusion: {
              in: [:acc_to_bank, :bank_to_acc, :acc_to_acc, :company_to_acc]
            }
  validates :amount, numericality: { greater_than: 0 }

  state_machine initial: :prepared do
    event :accept do
      transition prepared: :processed
    end
  end

  def self.all_by_account(account)
    where(source_acc_id: account.id).or(where(recipient_acc_id: account.id))
  end

  def type_by_context_of(account)
    return :withdraw if source_acc_id == account.id
    return :deposit if recipient_acc_id == account.id
    raise 'This operation does not belong to this account'
  end

  def money_source
    return Company::FinancesDpt if source_is_company?
    source_is_bank? ? Bank.bank_safe : Account.find(source_acc_id)
  end

  def money_recipient
    recipient_is_bank? ? Bank.bank_safe : Account.find(recipient_acc_id)
  end

  def operation_type
    super.to_sym
  end

  private

  def source_is_company?
    operation_type == :company_to_acc
  end

  def source_is_bank?
    operation_type == :bank_to_acc
  end

  def recipient_is_bank?
    operation_type == :acc_to_bank
  end
end
