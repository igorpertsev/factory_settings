# frozen_string_literal: true

require_relative 'base'

module FactorySettings
  module Storages
    class InMemory < Base

      def initialize
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

      def with_synchronize
        ::FactorySettings.storage_mutex.synchronize do 
          yield
        end  
      end
    end 
  end
end
