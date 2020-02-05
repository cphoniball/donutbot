require_relative './day_of_week'

# Keeps track of a recurring weekly schedule, where events occur on the same day
# every week. More than one day can be tracked, but days of the week cannot be added
# to the schedule more than once.
class WeeklySchedule
  attr_reader :days_of_week

  def initialize
    @days_of_week = []
  end

  def to_integers
    @days_of_week.map(&:to_i)
  end

  def days_relative_to_today
    today = Date.today.wday

    days = @days_of_week
    while @days_of_week.first.to_i < today
      days.rotate!
    end
    days
  end

  def add_day_of_week(day_of_week)
    @days_of_week = (@days_of_week << DayOfWeek.new(day_of_week)).uniq.sort
  end

  def remove_day_of_week(day_of_week)
    @days_of_week = @days_of_week - [DayOfWeek.new(day_of_week)]
  end
end
