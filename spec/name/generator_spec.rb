# frozen_string_literal: true

require "yaml"

RSpec.describe FactorySettings::Name::Generator do
  describe "#build" do
    subject { described_class.build }

    it "builds name with 2 upcase chars in beginning" do
      subject.chars.first(2).each do |x|
        expect(("A".."Z").to_a).to include(x)
      end
    end

    it "builds name with 3 digits in the end" do
      subject.chars.last(3).each do |x|
        expect(("0".."9").to_a).to include(x)
      end
    end

    it "builds 5 symbol name" do
      expect(subject.size).to eq(5)
    end

    context "small name integer part" do
      before { allow(SecureRandom).to receive(:random_number).and_return(1) }

      it "build integer part to 3 symbols length" do
        expect(subject.size).to eq(5)
        expect(subject.chars.last(3).join).to eq("001")
      end
    end
  end
end
