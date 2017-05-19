# Big evil corp, that controls everybody, even your balls
class Bank
  class << self
    delegate :available_money, to: :bank_safe
    Report = Struct.new(:name, :type, :amount, :state)

    def bank_safe
      BankSafe.first_or_create(available_money: 1_000_000_000)
    end

    def transfer_money(*args)
      operation = Operation.new(build_operation_config(*args))
      process(operation)
    end

    def add_account_for_newborn(user)
      account = Account.create!(user_id: user.id, available_money: 0)
      amount = rand(1000..10_000)
      transfer_money(self, account, amount, 'Gift some money for newborn')
    end

    def inform_about_death(user)
      return unless user.dead?
      account = user.account
      ActiveRecord::Base.transaction do
        transfer_money(account, self, account.available_money, 'Finally bank takes everything')
        account.disable!
      end
    end

    def generate_opeartions_report(user)
      user_account = user.account
      user_ops = Operation.all_by_account(user_account).order(updated_at: :desc)
      generate_report(user_ops, user_account)
    end

    private

    def generate_report(operations, user_account)
      result = []
      operations.each do |operation|
        result << Report.new(
          operation.name,
          operation.type_by_context_of(user_account),
          operation.amount,
          operation.state
        )
      end
      result
    end

    def process(operation)
      ActiveRecord::Base.transaction do
        operation.money_source.withdraw!(operation.amount)
        operation.money_recipient.deposit!(operation.amount)
        operation.accept!
      end
    end

    def build_operation_config(source, dest, amount, descr = 'money transfer')
      source_params(source)
        .merge(destination_params(dest))
        .merge(amount: amount, name: descr)
    end

    def source_params(source)
      if source.is_a?(Account)
        return { operation_type: :acc_to_acc, source_acc_id: source.id }
      end
      if source.is_a?(User)
        return { operation_type: :acc_to_acc, source_acc_id: source.account.id }
      end
      return { operation_type: :company_to_acc } if source == Company::FinancesDpt
      return { operation_type: :bank_to_acc } if source == Bank
      raise 'Unknown money source'
    end

    def destination_params(dest)
      return { recipient_acc_id: dest.id } if dest.is_a?(Account)
      return { recipient_acc_id: dest.account.id } if dest.is_a?(User)
      return { operation_type: :acc_to_bank } if dest == Bank
      raise 'Unknown money destination'
    end
  end
end
