require_relative '../src/weekly_schedule'
require 'timecop'

RSpec.describe WeeklySchedule do
  describe "#days_of_week" do
    it "returns days of the week in order" do
      subject.add_day_of_week(5)
      subject.add_day_of_week(2)
      subject.add_day_of_week(6)

      expect(subject.to_integers).to eq([2, 5, 6])
    end
  end

  describe "#relative_to_today" do
    it "returns the schedule relative to the current day" do
      subject.add_day_of_week(0)
      subject.add_day_of_week(4)
      subject.add_day_of_week(5)

      # Freeze to a Monday
      Timecop.freeze(Date.new(2020, 1, 6)) do
        expect(subject.days_relative_to_today.map(&:to_i)).to eq([4, 5, 0])
      end

      # Freeze to a Friday
      Timecop.freeze(Date.new(2020, 1, 10)) do
        expect(subject.days_relative_to_today.map(&:to_i)).to eq([5, 0, 4])
      end
    end
  end

  describe '#add_day_of_week' do
    context "day of week is not in the schedule" do
      it "adds day of week to the schedule" do
        subject.add_day_of_week(5)

        expect(subject.to_integers).to eq([5])
      end
    end

    context "day of week is already in the schedule" do
      it "schedule is unchanged" do
        subject.add_day_of_week(2)
        subject.add_day_of_week(4)
        subject.add_day_of_week(2)

        expect(subject.to_integers).to eq([2, 4])
      end
    end

    context "day of week is not valid" do
      it "raises an error" do
        expect { subject.add_day_of_week("adsfaef") }.to raise_error(/invalid date/)
        expect { subject.add_day_of_week(7) }.to raise_error(/cannot be higher than 6/)
        expect { subject.add_day_of_week(-1) }.to raise_error(/cannot be lower than 0/)
      end
    end
  end
end
