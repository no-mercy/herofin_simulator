# HR dept's user profile
class HrProfile < ApplicationRecord
  belongs_to :user

  state_machine initial: :hired do
    before_transition hired: :fired, do: :set_fire_date

    event :fire do
      transition hired: :fired
    end
  end

  private

  def set_fire_date
    self.fire_date = DateTime.now.utc
  end
end
