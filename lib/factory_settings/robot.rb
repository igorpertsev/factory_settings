# frozen_string_literal: true

require "factory_settings/name_create_support"

module FactorySettings
  # Robot instance settings class. Assings new name on initialization and provides functions to reset
  # robot to factory settings.
  class Robot
    include ::FactorySettings::NameCreateSupport
  end
end
