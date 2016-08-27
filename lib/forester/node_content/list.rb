module Forester
  module NodeContent
    class List < Base

      def include?(*args)
        super
      end
      alias_method :has?, :include?

      def fetch(*args)
        super
      end
      alias_method :get, :fetch

      def push(*args)
        super
      end
      alias_method :add!, :push

      def delete(*args)
        super
      end
      alias_method :del!, :delete

      def to_array
        Array.new(self)
      end

    end
  end
end
