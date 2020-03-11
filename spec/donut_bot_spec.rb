require_relative '../src/donut_bot'
require 'pathname'

require_relative '../src/file_system'

RSpec.describe DonutBot do
  let(:repository) { instance_double("ScheduleRepository") }
  let(:schedule) { instance_double("Schedule") }

  before(:each) do
    allow(ScheduleRepository).to receive(:new).and_return(repository)
  end

   # Make sure the schedule storage dir is empty before each run
  before(:each) do
    storage_path = Pathname.new(FileSystem.storage_path("schedules"))

    Dir.children(FileSystem.storage_path("schedules")).each do |file|
      File.delete(storage_path.join(file))
    end
  end

  describe "create schedule command" do
    it "creates the schedule and responds with confirmation" do
      expect(repository).to receive(:find_by_name).with("donuts")
      expect(repository).to receive(:save)

      expect(
        message: "#{SlackRubyBot.config.user} create schedule donuts"
      ).to respond_with_slack_message(/Schedule donuts created/)
    end
  end

  describe "add day of week to schedule" do
    context "schedule exists" do
      it "adds the day of the week to the schedule" do
        expect(schedule).to receive(:add_day_of_week).with("wednesday")
        expect(repository).to receive(:find_by_name).with("donuts").and_return(schedule)
        expect(repository).to receive(:save)

        expect(
          message: "#{SlackRubyBot.config.user} add wednesday to donuts"
        ).to respond_with_slack_message(/wednesday added to schedule donuts/)
      end
    end

    context "schedule does not exist" do
      it "responds that the schedule doesn't exist" do
        expect(repository).to receive(:find_by_name).with("donuts").and_return(nil)

        expect(
          message: "#{SlackRubyBot.config.user} add wednesday to donuts"
        ).to respond_with_slack_message(/schedule donuts does not exist/i)
      end
    end
  end

  describe "add person to the schedule" do
    it "adds the person to the schedule" do
      expect(schedule).to receive(:add_person).with("bob")
      expect(repository).to receive(:find_by_name).with("donuts").and_return(schedule)
      expect(repository).to receive(:save)

      expect(
        message: "#{SlackRubyBot.config.user} add bob to donuts"
      ).to respond_with_slack_message(/bob added to schedule donuts/)
    end
  end
end
