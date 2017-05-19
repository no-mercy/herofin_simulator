# Company's HR Derartment
module HumanResourcesDepartment
  extend ActiveSupport::Concern

  def hire(user)
    HrProfile.create!(user_id: user.id, enroll_date: DateTime.now.utc)
    Company::FinancesDpt.create_finance_profile(user)
    user.become_worker!
  end

  def all_active_workers
    HrProfile.with_state(:hired).map(&:user)
  end

  def fire(user)
    ActiveRecord::Base.transaction do
      Company::FinancesDpt.pay_last_salary(user)
      HrProfile.find_by(user_id: user.id).fire!
    end
  end
end
