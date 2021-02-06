# frozen_string_literal: true

require "yaml"
require_relative "base"

module FactorySettings
  module Storages
    # Storage class that persists all names data to the disk every time after after changes.
    # Reads disk storage on each operation to ensure all changes from other processes applied.
    class File < Base
      STORAGE_FILE_PATH = "#{::FactorySettings.file_storage_path}/name_storage.yml"

      def initialize
        super
        @storage = ::File.file?(STORAGE_FILE_PATH) ? YAML.load_file(STORAGE_FILE_PATH) : {}
      end

      def exists?(key)
        with_storage_access(ignore_persist: true) { @storage.key?(key.to_sym) }
      end

      def add!(key)
        with_storage_access do
          raise AlreadyExists, "Robot with such name already exists" if @storage.key?(key.to_sym)

          @storage[key.to_sym] = true
        end
      end

      def add(key)
        with_storage_access { @storage[key.to_sym] = true }
      end

      def remove(key)
        with_storage_access { @storage.delete(key.to_sym) }
      end

      def reset!
        ::FactorySettings.storage_mutex.synchronize do
          ::File.delete(STORAGE_FILE_PATH) if ::File.file?(STORAGE_FILE_PATH)
          @storage = {}
        end
      end

      private

      def with_storage_access(ignore_persist: false)
        ::FactorySettings.storage_mutex.synchronize do
          read_storage_content
          result = yield
          persist_change unless ignore_persist
          result
        end
      end

      def read_storage_content
        @storage = ::File.file?(STORAGE_FILE_PATH) ? YAML.load_file(STORAGE_FILE_PATH) : {}
      end

      def persist_change
        ::File.write(STORAGE_FILE_PATH, @storage.to_yaml)
      end
    end
  end
end
