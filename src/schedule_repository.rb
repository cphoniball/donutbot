require 'yaml/store'
require_relative './schedule'
require_relative './file_system'

class ScheduleRepository
  def find_by_name(name)
    # TODO: Check if the schedule doesn't exist
    schedule = Schedule.new(name)
    store = schedule_store(schedule)

    store.transaction(true) do
      store[:people].each { |person| schedule.add_person(person) }
      store[:weekly_schedule].each { |day_of_week| schedule.add_day_of_week(day_of_week) }
    end

    schedule
  end

  def create(name)
    # TODO: Check if this schedule doesn't already exist
    save(Schedule.new(name))
  end

  def save(schedule)
    store = schedule_store(schedule)

    store.transaction do
      store[:name] = schedule.name
      store[:people] = schedule.people
      store[:weekly_schedule] = schedule.weekly_schedule.to_integers
    end

    schedule
  end

  def update(schedule, name: name)
    # TODO: Delete the old schedule and save to a new locations
  end

  def destroy(schedule)
    # TODO: Check existence
    File.delete(schedule_path(schedule))
  end

  private

  def schedule_store(schedule)
    YAML::Store.new(schedule_path(schedule), thread_safe: true)
  end

  def schedule_path(schedule)
    FileSystem.storage_path("schedules", "#{schedule.name}.yml")
  end
end
