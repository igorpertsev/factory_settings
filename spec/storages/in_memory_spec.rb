# frozen_string_literal: true

RSpec.describe FactorySettings::Storages::InMemory do
  subject { described_class.instance }

  before do
    allow(FactorySettings).to receive(:name_storage).and_return(subject)
    subject.reset!
    subject.add!(:test)
  end

  describe "interface" do
    it { is_expected.to respond_to(:exists?) }
    it { is_expected.to respond_to(:add!) }
    it { is_expected.to respond_to(:add) }
    it { is_expected.to respond_to(:remove) }
  end

  describe "#exists?" do
    it "returns true if name exists" do
      expect(subject.exists?(:test)).to be_truthy
    end

    it "returns false if no name present in storage" do
      expect(subject.exists?(:missing)).to be_falsey
    end
  end

  describe "#add!" do
    it "adds name to storage if not present" do
      expect(subject.add!(:test2)).to be_truthy
    end

    it "raise error if name already in storage" do
      expect { subject.add!(:test) }.to raise_error(described_class::AlreadyExists)
    end
  end

  describe "#remove" do
    it "removes name from storage" do
      subject.remove(:test)
      expect(subject.exists?(:test)).to be_falsey
    end
  end

  describe "#reset!" do
    it "clears inmemory storage" do
      subject.reset!
      expect(subject.instance_variable_get("@storage")).to be_empty
    end
  end
end
