module Forester
  class Version
    MAJOR = 4
    MINOR = 2
    PATCH = 1
    PRE = nil

    class << self

      def to_s
        [MAJOR, MINOR, PATCH, PRE].compact.join('.')
      end

    end

  end
end
