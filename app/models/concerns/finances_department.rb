# Company's Finances Derartment
module FinancesDepartment
  extend ActiveSupport::Concern

  def create_finance_profile(user)
    FinanceProfile.create!(user_id: user.id, enroll_date: DateTime.now.utc)
  end

  def pay_salary_to_workers
    Company::HumanResourcesDpt.all_active_workers.each do |worker|
      finance_profile = FinanceProfile.find_by(user: worker)
      next unless finance_profile.salary_time_has_come?
      pay_salary(finance_profile)
    end
  end

  def pay_last_salary(user)
    finance_profile = FinanceProfile.find_by(user: user)
    pay_salary(finance_profile)
  end

  def withdraw!(_)
    # company has unlimited resouces
  end

  private

  def pay_salary(profile)
    amount = (profile.unpaid_periods * rand(300..1200)).round
    return if amount.zero?
    ActiveRecord::Base.transaction do
      Bank.transfer_money(self, profile.user, amount, "Salary (#{profile.unpaid_periods} pay periods)")
      profile.salary_paid!
    end
  end
end
