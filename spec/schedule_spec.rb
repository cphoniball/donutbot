require 'timecop'
require_relative '../src/schedule'

RSpec.describe Schedule do
  describe '#add_person' do
    context 'person is not already in the schedule' do
      it 'adds the person into the schedule' do
        subject.add_person("Person")

        expect(subject.people).to eq(["Person"])
      end
    end

    context 'person is already in the schedule' do
      it 'adds them to the schedule a second time' do
        2.times { subject.add_person("Person") }

        expect(subject.people).to eq(["Person", "Person"])
      end
    end
  end

  describe '#remove_person' do
    context "person is not in the schedule" do
      it "doesn't change the schedule" do
        subject.add_person("Person")
        subject.remove_person("Someone else")

        expect(subject.people).to eq(["Person"])
      end
    end

    context "person is in the schedule once" do
      it "removes them from the schedule" do
        subject.add_person("Person")
        subject.add_person("Someone else")
        subject.remove_person("Person")

        expect(subject.people).to eq(["Someone else"])
      end
    end

    context "person is in the schedule twice" do
      it "only removes them once" do
        subject.add_person("Person")
        subject.add_person("Person")
        subject.remove_person("Person")

        expect(subject.people).to eq(["Person"])
      end
    end
  end

  describe "#get_schedule" do
    context "users and days have been added to the schedule" do
      it "returns all people and their next donut days" do
        Timecop.freeze(Date.new(2020, 1, 1)) do
          subject.add_day_of_week("Friday")

          subject.add_person("Tom")
          subject.add_person("Bob")
          subject.add_person("Jerry")

          expect(subject.get_schedule).to eq([
            { day: Date.new(2020, 1, 3), person: "Tom" },
            { day: Date.new(2020, 1, 10), person: "Bob" },
            { day: Date.new(2020, 1, 17), person: "Jerry" }
          ])
        end
      end
    end
  end

  describe "#get_formatted_schedule" do
    context "users and days have been added to the schedule" do
      it "returns all people and their next donut days in a formatted string" do
        Timecop.freeze(Date.new(2020, 1, 1)) do
          subject.add_day_of_week("Friday")

          subject.add_person("Tom")
          subject.add_person("Bob")
          subject.add_person("Jerry")

          expect(subject.get_formatted_schedule).to eq([
            "Friday Jan 3: Tom",
            "Friday Jan 10: Bob",
            "Friday Jan 17: Jerry"
          ].join("\n")
        )
        end
      end
    end
  end
end
