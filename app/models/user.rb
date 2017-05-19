# One, who appears for nothing, and then disappears to nowhere
class User < ApplicationRecord
  before_create :set_user_born_date
  after_create :inform_bank_about_newborn
  has_one :account, dependent: :destroy

  scope :all_alive, -> { where.not(state: :dead) }
  scope :old_enough_to_work, lambda {
    all_alive.where(state: :newborn).where('birthday < ?', 18.minutes.ago)
  }
  scope :old_enough_to_die, -> { all_alive.where('birthday < ?', 5.hours.ago) }

  validates :name, presence: true

  state_machine initial: :newborn do
    after_transition newborn: :adult, do: :find_job
    before_transition worker: :dead, do: :fix_time_of_death
    after_transition worker: :dead, do: :inform_officials_about_death

    event :celebrate_adulthood do
      transition newborn: :adult
    end

    event :become_worker do
      transition adult: :worker
    end

    event :death do
      transition worker: :dead
    end
  end

  def self.kill_old_users!
    old_enough_to_die.each(&:death!)
  end

  def self.grow_up_childs!
    old_enough_to_work.each(&:celebrate_adulthood!)
  end

  def age
    to_compare = dead? ? time_of_death : DateTime.now.utc
    ((to_compare - birthday) / 60).round
  end

  private

  def set_user_born_date
    self.birthday = DateTime.now.utc
  end

  def fix_time_of_death
    self.time_of_death = DateTime.now.utc
  end

  def inform_bank_about_newborn
    Bank.add_account_for_newborn(self)
  end

  def find_job
    Company.ask_for_job(self)
  end

  def inform_officials_about_death
    Company.inform_about_death(self)
    Bank.inform_about_death(self)
  end
end
