class HerofinWorldLoop < ActiveJob::Base
  def perform
    User.grow_up_childs!
    User.kill_old_users!
    Company::FinancesDpt.pay_salary_to_workers
  end
end
