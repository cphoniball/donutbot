require_relative '../src/schedule'
require_relative '../src/schedule_repository'

# Integration tests because these interact with the filesystem
RSpec.describe ScheduleRepository, :integration do
  let(:schedule) do
    schedule = Schedule.new("Test Schedule")
    schedule.add_person("Bob")
    schedule.add_day_of_week("Friday")
    schedule
  end

  # Make sure each spec has a clean environment
  before(:each) { ScheduleRepository.new.destroy(Schedule.new("Test Schedule")) }

  describe "#find_by_name" do
    context "schedule does not exist" do
      it "returns nil" do
        expect(subject.find_by_name("Test Schedule")).to be_nil
      end
    end

    context "schedule exists" do
      it "returns the schedule" do
        subject.save(schedule)

        expect(subject.find_by_name("Test Schedule")).to be_a(Schedule)
      end
    end
  end

  describe "#save" do
    it "saves the schedule" do
      subject.save(schedule)

      retrieved = subject.find_by_name(schedule.name)

      expect(retrieved.name).to eq("Test Schedule")
      expect(retrieved.people).to eq(["Bob"])
      expect(retrieved.weekly_schedule.to_integers).to eq([5])
    end

    context "schedule name changes" do
      it "saves under the new name and deletes the old one" do
        # TODO: Clean up old schedules
      end
    end
  end

  describe "#update" do
    before(:each) { ScheduleRepository.new.destroy(Schedule.new("New Schedule Name")) }

    it "saves the schedule under a new name" do
      subject.save(schedule)
      subject.update(schedule, name: "New Schedule Name")

      expect(subject.find_by_name("Test Schedule")).to be_nil
      expect(subject.find_by_name("New Schedule Name")).not_to be_nil
    end
  end

  describe "#destroy" do
    it "destroys the schedule" do
      subject.save(schedule)
      subject.destroy(schedule)

      expect(subject.find_by_name("Test Schedule")).to be_nil
    end
  end
end
