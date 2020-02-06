require 'yaml/store'
require_relative './schedule'

class ScheduleRepository
  def find(id)
  end

  def find_by(**properties)
  end

  def create
    schedule = Schedule.new
    save(schedule)
    schedule
  end

  def save(schedule)
  end

  def update(schedule, name: name)
  end

  def destroy(schedule)
  end
end
