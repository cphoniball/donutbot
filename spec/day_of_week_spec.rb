require 'timecop'
require 'pry'
require_relative '../src/day_of_week'

RSpec.describe DayOfWeek do
  describe ".new" do
    context "day of week is a string" do
      it "parses day of the week to an integer" do
        expect(described_class.new("Sunday").day_of_week).to eq(0)
        expect(described_class.new("Tuesday").day_of_week).to eq(2)
        expect(described_class.new("Saturday").day_of_week).to eq(6)
      end
    end

    context "day of week is an integer" do
      it "sets the day of the week" do
        expect(described_class.new(0).day_of_week).to eq(0)
        expect(described_class.new(2).day_of_week).to eq(2)
        expect(described_class.new(6).day_of_week).to eq(6)
      end
    end

    context "day of week is something else" do
      it "raises" do
        expect { described_class.new([]) }.to raise_error(/Day of week is not a recognized type/)
      end
    end
  end

  describe "#to_s" do
    it "returns the day as a string" do
      expect(described_class.new(1).to_s).to eq("Monday")
    end
  end

  describe "#next_occurrence_from" do
    it "returns the next occurrence of the day of the week from the given day" do
      expect(
        described_class.new(1).next_occurrence_from(Date.new(2020, 1, 1))
      ).to eq(Date.new(2020, 1, 6))
    end
  end

  describe "#<=>" do
    it "sorts days of week according to their integer value" do
      first = DayOfWeek.new(1)
      second = DayOfWeek.new(2)
      third = DayOfWeek.new(5)

      expect([third, first, second].sort).to eq([first, second, third])
    end
  end
end
