# frozen_string_literal: true

require 'securerandom'

module FactorySettings
  module Name
    class Generator 
      CHARS_SET = ('A'..'Z').to_a.freeze
      NUMERIC_LIMIT = 999
      NUMERIC_LIMIT_LENGTH = NUMERIC_LIMIT.to_s.size

      class << self
        def build
          "#{symbolic_part}#{integer_part}"
        end

        def symbolic_part
          CHARS_SET.sample(2).join
        end
    
        def integer_part
          format("%0#{NUMERIC_LIMIT_LENGTH}d", SecureRandom.random_number(NUMERIC_LIMIT))
        end
      end

      private_class_method :symbolic_part
      private_class_method :integer_part
    end
  end
end
