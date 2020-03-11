require 'slack-ruby-bot'
require_relative './schedule'
require_relative './schedule_repository'

class DonutBot < SlackRubyBot::Bot
  def self.schedule_repository
    ScheduleRepository.new
  end

  # Create a new schedule
  match /(make|create) schedule (?<name>\w*)/i do |client, data, match|
    if schedule = schedule_repository.find_by_name(match[:name])
      next client.say(text: "Schedule #{match[:name]} already exists.", channel: data.channel)
    end

    schedule = Schedule.new(match[:name])
    schedule_repository.save(schedule)

    client.say(text: "Schedule #{match[:name]} created.", channel: data.channel)
  end

  # Add a person or day of week to the schedule
  match /add (?<day_or_person>\w*) to (?<schedule_name>\w*)/i do |client, data, match|
    day_or_person = match[:day_or_person]
    schedule_name = match[:schedule_name]

    unless(schedule = schedule_repository.find_by_name(schedule_name))
      next client.say(text: "Schedule #{schedule_name} does not exist.", channel: data.channel)
    end

    if DayOfWeek.valid?(day_or_person)
      schedule.add_day_of_week(day_or_person)
    else
      schedule.add_person(day_or_person)
    end

    schedule_repository.save(schedule)

    client.say(text: "#{day_or_person} added to schedule #{schedule_name}.", channel: data.channel)
  end

  # Remove a person or day of week from the schedule
  # match /remove (?<thing>\w*) from (?<schedule_name>\w*) do |client, data, match|
  #   schedule = ScheduleRepository.find_by_name(match[:schedule_name])

  #   if DayOfWeek.new(thing).is_valid?
  #     schedule.remove_day_of_week(thing)
  #   else
  #     schedule.removes_person(thing)
  #   end

  #   ScheduleRepository.save(schedule)

  #   client.say(text: "#{match[:thing]} added to schedule #{match[:schedule]}.", channel: data.channel)
  # end

  # TODO: Get the schedule from the chatbot
end
