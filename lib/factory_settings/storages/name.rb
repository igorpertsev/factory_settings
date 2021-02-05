# frozen_string_literal: true

require 'singleton'
require 'yaml'

module FactorySettings
  module Storages
    class Name
      include Singleton

      STORAGE_FILE_PATH = "#{::FactorySettings.file_storage_path}/name_storage.yml".freeze
      
      def initialize
        @storage = File.file?(STORAGE_FILE_PATH) ? YAML.load_file(STORAGE_FILE_PATH) : {}
      end

      def exists?(key)
        @storage.key?(key)
      end

      def add(key)
        @storage[key] = true
        persist_change
      end

      def remove(key)
        @storage.delete(key)
        persist_change
      end
      
      private 
      
      def persist_change
        File.write(STORAGE_FILE_PATH, @storage.to_yaml)
      end
    end 
  end
end
