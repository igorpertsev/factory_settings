# frozen_string_literal: true

RSpec.describe FactorySettings::Robot do
  let(:storage) { FactorySettings.name_storage }
  it "assigns new name on first initialize" do
    expect_any_instance_of(described_class).to receive(:name)
    described_class.new
  end

  describe "#name" do
    subject { described_class.new }

    let(:name) { "AC123" }
    let(:name2) { "AB456" }

    context "name assigned" do
      before do
        storage.reset!
        allow(FactorySettings::Name::Generator).to receive(:build).and_return(name, name2)
      end

      context "no collisions" do
        it "use name generator to build name" do
          expect(FactorySettings::Name::Generator).to receive(:build).and_return(name)
          subject
        end

        it "stores name in name storage" do
          expect(storage.exists?(name)).to be_falsey
          subject
          expect(storage.exists?(name)).to be_truthy
        end
      end

      context "collision met" do
        before { storage.add!(name) }

        it "attempts to get new name again" do
          expect(FactorySettings::Name::Generator).to receive(:build).and_return(name)
          expect(FactorySettings::Name::Generator).to receive(:build).and_return(name2)
          subject
        end

        it "stores second name in name storage" do
          expect(storage.exists?(name2)).to be_falsey
          expect(storage.exists?(name)).to be_truthy

          subject
          expect(storage.exists?(name)).to be_truthy
          expect(storage.exists?(name2)).to be_truthy
        end
      end
    end

    context "too many attempts done" do
      subject { described_class.new }

      let(:name) { "AC123" }

      before do
        storage.reset!
        storage.add!(name)
        names = []
        51.times { names << name }
        allow(FactorySettings::Name::Generator).to receive(:build).and_return(name)
      end

      it "attempts to get new name 50 times" do
        expect(FactorySettings::Name::Generator).to receive(:build).and_return(name).exactly(50).times
        error = "Too many attemps to generate name. Please try again later or change name format"

        expect { subject }.to raise_error(described_class::TooManyAttempts, error)
      end
    end
  end
end
