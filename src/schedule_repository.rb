require 'digest'
require 'yaml/store'

require_relative './schedule'
require_relative './file_system'

class ScheduleRepository
  def find_by_name(name)
    schedule = Schedule.new(name)

    return nil unless schedule_exist?(schedule)

    store = schedule_store(schedule)

    store.transaction(true) do
      store[:people].each { |person| schedule.add_person(person) }
      store[:weekly_schedule].each { |day_of_week| schedule.add_day_of_week(day_of_week) }
    end

    schedule
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
    old_schedule = Schedule.new(schedule.name)

    schedule.name = name
    save(schedule)

    destroy(old_schedule)
  end

  def destroy(schedule)
    File.delete(schedule_path(schedule)) if schedule_exist?(schedule)
  end

  private

  def schedule_exist?(schedule)
    schedule_path(schedule).exist?
  end

  def schedule_store(schedule)
    YAML::Store.new(schedule_path(schedule), thread_safe: true)
  end

  def schedule_path(schedule)
    basename = name_hash(schedule.name)
    FileSystem.storage_path("schedules", "#{basename}.yml")
  end

  # Hash the name of the schedule so it's safe to use as a file name
  def name_hash(name)
    Digest::SHA1.hexdigest(name)
  end
end
