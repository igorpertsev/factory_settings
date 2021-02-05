# frozen_string_literal: true

require 'singleton'
require 'yaml'

module FactorySettings
  module Storages
    class Name
      include Singleton

      class AlreadyExists < StandardError; end

      STORAGE_FILE_PATH = "#{::FactorySettings.file_storage_path}/name_storage.yml".freeze
      
      def initialize
        @storage = File.file?(STORAGE_FILE_PATH) ? YAML.load_file(STORAGE_FILE_PATH) : {}
      end

      def exists?(key)
        with_storage_access(true) { @storage.key?(key.to_sym) }
      end

      def add!(key)
        with_storage_access do 
          raise AlreadyExists, "Robot with such name already exists" if exists?(key)
          @storage[key.to_sym] = true
        end
      end

      def add(key)
        with_storage_access { @storage[key.to_sym] = true }
      end

      def remove(key)
        with_storage_access { @storage.delete(key.to_sym) }
      end
      
      private 

      def with_storage_access(ignore_persist = false)
        ::FactorySettings.storage_mutex.synchronize do 
          read_storage_content
          yield
          persist_change unless ignore_persist
        end  
      end

      def read_storage_content
        @storage = File.file?(STORAGE_FILE_PATH) ? YAML.load_file(STORAGE_FILE_PATH) : @storage
      end
      
      def persist_change
        File.write(STORAGE_FILE_PATH, @storage.to_yaml)
      end
    end 
  end
end
