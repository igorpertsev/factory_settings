# frozen_string_literal: true

module FactorySettings
  # Robot instance settings class. Assings new name on initialization and provides functions to reset
  # robot to factory settings.
  class Robot
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
          name = FactorySettings::Name::Generator.build
          success = begin
            FactorySettings.name_storage.add!(name)
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
      FactorySettings.name_storage.remove(@name)
      @name = nil
    end
  end
end
