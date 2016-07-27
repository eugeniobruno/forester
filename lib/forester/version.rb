module Forester
  class Version
    MAJOR = 3
    MINOR = 0
    PATCH = 0
    PRE = nil

    class << self

      def to_s
        [MAJOR, MINOR, PATCH, PRE].compact.join('.')
      end

    end

  end
end
