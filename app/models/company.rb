# You will work there until death
class Company
  class HumanResourcesDpt
    extend HumanResourcesDepartment
  end

  class FinancesDpt
    extend FinancesDepartment
  end

  class << self
    def ask_for_job(user)
      return unless user.adult?
      HumanResourcesDpt.hire(user)
    end

    def inform_about_death(user)
      return unless user.dead?
      HumanResourcesDpt.fire(user)
    end
  end
end
