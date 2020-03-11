require 'pry'
require 'date'

class DayOfWeek
  attr_reader :day_of_week

  DAYS_OF_WEEK = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ].freeze

  def initialize(day_of_week)
    case day_of_week
    when Integer
      set_day_of_week_integer(day_of_week)
    when String
      set_day_of_week_string(day_of_week)
    else
      raise "Day of week is not a recognized type."
    end
  end

  def self.valid?(day_of_week)
    begin
      DayOfWeek.new(day_of_week)
      true
    rescue
      false
    end
  end

  def to_s
    DAYS_OF_WEEK[day_of_week]
  end

  def to_i
    day_of_week
  end

  def hash
    day_of_week
  end

  def eql?(other)
    day_of_week == other.day_of_week
  end

  def <=>(other)
    day_of_week <=> other.day_of_week
  end

  # TODO: Optimize this, there's a calculation we can do instead of this naive loop iteration
  def next_occurrence_from(date)
    loop do
      date = date.next
      return date if date.wday == day_of_week
    end
  end

  private

  def set_day_of_week_string(day_of_week)
    @day_of_week = Date.parse(day_of_week).wday if day_of_week.class == String
  end

  def set_day_of_week_integer(day_of_week)
    raise "Day of week cannot be higher than 6" unless day_of_week <= 6
    raise "Day of week cannot be lower than 0" unless day_of_week >= 0

    @day_of_week = day_of_week
  end
end
