# Finance dept's user profile
class FinanceProfile < ApplicationRecord
  belongs_to :user

  def salary_paid!
    self.last_paid_time = DateTime.now.utc
    save!
  end

  def salary_time_has_come?
    1 <= unpaid_periods
  end

  def unpaid_periods
    ((DateTime.now.utc - last_payment_stamp) / 300).round(2)
  end

  private

  def last_payment_stamp
    last_paid_time || enroll_date
  end
end
