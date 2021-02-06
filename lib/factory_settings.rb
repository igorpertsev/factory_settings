# frozen_string_literal: true

require_relative "factory_settings/version"

module FactorySettings
  class Error < StandardError; end
  class InvalidNameStorageValue < StandardError; end

  class << self
    attr_accessor :name_storage, :file_storage_path

    def config
      yield self
      validate_name_storage if @name_storage
    end

    def file_storage_path
      @file_storage_path || File.join((File.dirname __dir__), "tmp")
    end
    
    def name_storage 
      @name_storage || ::FactorySettings::Storages::File.instance
    end

    def storage_mutex
      @storage_mutex ||= Mutex.new
    end

    def validate_name_storage
      missing_methods = []
      missing_methods << :exists? unless @name_storage.respond_to?(:exists?)
      missing_methods << :add! unless @name_storage.respond_to?(:add!)
      missing_methods << :remove unless @name_storage.respond_to?(:remove)

      rollback_storage(missing_methods) if missing_methods.size > 0
    end
    
    def rollback_storage(missing_methods)
      @name_storage = nil
      raise InvalidNameStorageValue, "Name storage should implement #{missing_methods}" 
    end
  end

  private_class_method :rollback_storage
  private_class_method :validate_name_storage
end
