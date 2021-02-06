# frozen_string_literal: true

module FactorySettings
  # Module that implements robot naming logic. Can be included in any model that has access to it
  # to provide new name assign and reset to factory settings logic.
  module NameCreateSupport
    MAX_NAME_REQUEST_ATTEMPTS = 50

    class TooManyAttempts < StandardError; end

    def initialize
      name # initializing new robot name
    end

    def name
      @name ||= begin
        attempts = 0
        success = false
        name = nil
        while attempts < MAX_NAME_REQUEST_ATTEMPTS && !success
          name = ::FactorySettings::Name::Generator.build
          success = begin
            ::FactorySettings.name_storage.add!(name)
          rescue StandardError
            false
          end
          attempts += 1
        end
        unless success
          raise TooManyAttempts,
                "Too many attemps to generate name. Please try again later or change name format"
        end

        name
      end
    end

    def reset!
      ::FactorySettings.name_storage.remove(@name)
      @name = nil
    end
  end
end
