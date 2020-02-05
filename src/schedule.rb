require 'forwardable'
require_relative './day_of_week'

class Schedule
  extend Forwardable

  attr_reader :people
  attr_reader :weekly_schedule

  def_delegators :@weekly_schedule, :add_day_of_week, :remove_day_of_week

  def initialize
    @people = []
    @weekly_schedule = WeeklySchedule.new
  end

  def get_schedule
    days = weekly_schedule.days_relative_to_today
    date = nil

    @people.map do |person|
      date = days.first.next_occurrence_from(date || Date.today - 1)
      days.rotate!

      { day: date, person: person }
    end
  end

  def add_person(person)
    @people << person
  end

  def remove_person(person)
    index = @people.find_index(person)
    @people.delete_at(index) if index
  end
end
