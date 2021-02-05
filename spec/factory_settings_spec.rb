# frozen_string_literal: true

require 'ostruct'

RSpec.describe FactorySettings do
  it "has a version number" do
    expect(FactorySettings::VERSION).not_to be nil
  end

  describe "configurations" do 
    describe "file_storage_path" do 
      it "has default value" do 
        expect(described_class.file_storage_path).not_to be nil
      end

      it "defaults to tmp directory in gem" do 
        path = File.join((File.dirname __dir__), "tmp")
        expect(described_class.file_storage_path).to eq(path)
      end

      it "can be set via config" do 
        described_class.config { |c| c.file_storage_path = "test" }
        expect(described_class.file_storage_path).to eq("test")
      end
    end

    describe "name_storage" do
      it "has default value" do 
        expect(described_class.name_storage).not_to be_nil
      end 

      it "use FactorySettings::Storages::Name class instance" do 
        instance = FactorySettings::Storages::Name.instance
        expect(described_class.name_storage).to eq(instance)
      end 

      context "passing storage in configs" do 
        context "invalid storages" do 
          let(:instance) { FactorySettings::Storages::Name.instance }

          it "validates :add! method presence and rollbacks to default" do 
            message = "Name storage should implement [:add!]"
            expect { 
              described_class.config { |c| c.name_storage = OpenStruct.new(exists?: true, remove: true) }
            }.to raise_error(described_class::InvalidNameStorageValue, message)
            expect(described_class.name_storage).to eq(instance)
          end
          
          it "validates :exists? method presence and rollbacks to default" do 
            message = "Name storage should implement [:exists?]"
            expect { 
              described_class.config { |c| c.name_storage = OpenStruct.new(add!: true, remove: true) }
            }.to raise_error(described_class::InvalidNameStorageValue, message)
            expect(described_class.name_storage).to eq(instance)
          end
          
          it "validates :remove method presence and rollbacks to default" do 
            message = "Name storage should implement [:remove]"
            expect { 
              described_class.config { |c| c.name_storage = OpenStruct.new(exists?: true, add!: true) }
            }.to raise_error(described_class::InvalidNameStorageValue, message)
            expect(described_class.name_storage).to eq(instance)
          end
        end

        it "set correct storage" do 
          storage = OpenStruct.new(exists?: true, add!: true, remove: true)
          described_class.config { |c| c.name_storage = storage }
          expect(described_class.name_storage).to eq(storage)
        end
      end
    end
  end
end
