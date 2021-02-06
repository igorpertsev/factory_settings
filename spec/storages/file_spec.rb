# frozen_string_literal: true

require 'yaml'

RSpec.describe FactorySettings::Storages::File do
  subject { described_class.instance }

  let(:path) { File.join((File.dirname __dir__), "tmp") }
  let(:storage_path) { described_class::STORAGE_FILE_PATH }

  before { allow(FactorySettings).to receive(:file_storage_path).and_return(path) }

  describe "interface" do 
    it { is_expected.to respond_to(:exists?) }
    it { is_expected.to respond_to(:add!) }
    it { is_expected.to respond_to(:remove) }
  end

  describe "#exists?" do 
    context "no stored data exists" do 
      before do 
        File.delete(storage_path) if File.file?(storage_path)
        subject.add!(:test)
      end

      it "returns true if name exists" do 
        expect(subject.exists?(:test)).to be_truthy
      end

      it "returns false if no name present in storage" do 
        expect(subject.exists?(:missing)).to be_falsey
      end
    end

    context "data already exists in yml file" do 
      before { File.write(storage_path, { test: true, test2: true }.to_yaml) }

      it "returns true if name exists" do 
        expect(subject.exists?(:test)).to be_truthy
      end

      it "returns false if no name present in storage" do 
        expect(subject.exists?(:missing)).to be_falsey
      end
    end
  end

  describe "#add!" do 
    context "no stored data exists" do 
      before do 
        File.delete(storage_path) if File.file?(storage_path)
        subject.add!(:test)
      end

      it "adds name to storage if not present" do 
        expect(subject.add!(:test2)).to be_truthy
      end

      it "raise error if name already in storage" do 
        expect { subject.add!(:test) }.to raise_error(described_class::AlreadyExists)
      end

      it "persists storage on disk after adding new name" do 
        subject.add!(:test2)
        file_data = YAML.load_file(storage_path)
        expect(file_data.keys).to include(:test)
        expect(file_data.keys).to include(:test2)
      end
    end

    context "data already exists in yml file" do 
      before { File.write(storage_path, { test: true }.to_yaml) }

      it "adds name to storage if not present" do 
        expect(subject.add!(:test2)).to be_truthy
      end

      it "raise error if name already in storage" do 
        expect { subject.add!(:test) }.to raise_error(described_class::AlreadyExists)
      end

      it "persists storage on disk after adding new name" do 
        subject.add!(:test2)
        file_data = YAML.load_file(storage_path)
        expect(file_data.keys).to include(:test)
        expect(file_data.keys).to include(:test2)
      end
    end
  end

  describe "#remove" do 
    context "no stored data exists" do 
      before do 
        File.delete(storage_path) if File.file?(storage_path)
        subject.add!(:test)
      end

      it "removes name from storage" do 
        subject.remove(:test)
        expect(subject.exists?(:test)).to be_falsey
      end

      it "persists storage on disk after removing name" do 
        subject.remove(:test)
        file_data = YAML.load_file(storage_path)
        expect(file_data.keys).to be_empty
      end
    end

    context "data already exists in yml file" do 
      before { File.write(storage_path, { test: true }.to_yaml) }

      it "removes name from storage" do 
        subject.remove(:test)
        expect(subject.exists?(:test)).to be_falsey
      end

      it "persists storage on disk after removing name" do 
        subject.remove(:test)
        file_data = YAML.load_file(storage_path)
        expect(file_data.keys).to be_empty
      end
    end
  end

  describe "#reset!" do 
    before { File.write(storage_path, { test: true }.to_yaml) }

    it "removes storage file from disk" do 
      subject.reset!
      expect(File.file?(storage_path)).to be_falsey
    end

    it "clears inmemory storage" do 
      subject.reset!
      expect(subject.instance_variable_get("@storage")).to be_empty
    end
  end
end
