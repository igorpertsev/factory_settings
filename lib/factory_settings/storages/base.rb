# frozen_string_literal: true

require 'singleton'

module FactorySettings
  module Storages
    class Base
      include Singleton

      class AlreadyExists < StandardError; end

      def exists?(key)
        raise NotImplementedError
      end

      def add!(key)
        raise NotImplementedError
      end

      def add(key)
        raise NotImplementedError
      end

      def remove(key)
        raise NotImplementedError
      end

      def reset!
        raise NotImplementedError
      end
    end 
  end
end
