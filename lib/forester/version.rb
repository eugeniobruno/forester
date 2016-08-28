module Forester
  class Version
    MAJOR = 4
    MINOR = 1
    PATCH = 0
    PRE = nil

    class << self

      def to_s
        [MAJOR, MINOR, PATCH, PRE].compact.join('.')
      end

    end

  end
end
