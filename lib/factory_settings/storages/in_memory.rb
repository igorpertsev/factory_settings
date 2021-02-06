# frozen_string_literal: true

require_relative "base"

module FactorySettings
  module Storages
    # In memory storage class. Only stores data in memory and resets all on application restart.
    class InMemory < Base
      def initialize
        super
        @storage = {}
      end

      def exists?(key)
        with_synchronize { @storage.key?(key.to_sym) }
      end

      def add!(key)
        with_synchronize do
          raise AlreadyExists, "Robot with such name already exists" if @storage.key?(key.to_sym)

          @storage[key.to_sym] = true
        end
      end

      def add(key)
        with_synchronize { @storage[key.to_sym] = true }
      end

      def remove(key)
        with_synchronize { @storage.delete(key.to_sym) }
      end

      def reset!
        with_synchronize { @storage = {} }
      end

      private

      def with_synchronize(&block)
        ::FactorySettings.storage_mutex.synchronize(&block)
      end
    end
  end
end
