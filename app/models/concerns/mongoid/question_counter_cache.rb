module Mongoid
  module QuestionCounterCache
    extend ActiveSupport::Concern

    included do
      after_create  :increment_counter
      after_destroy :decrement_counter
    end

    private
    def increment_counter
      self.exercise.lo.inc(:questions_available_count, 1)
    end

    def decrement_counter
      self.exercise.lo.inc(:questions_available_count, -1)
    end
  end
end
