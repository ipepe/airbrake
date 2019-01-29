module Airbrake
  module Rails
    # ActiveRecordSubscriber sends SQL information, including performance data.
    #
    # @since v8.1.0
    class ActiveRecordSubscriber
      def initialize(notifier)
        @notifier = notifier
      end

      def call(*args)
        return unless (route = Thread.current[:airbrake_rails_route])

        event = ActiveSupport::Notifications::Event.new(*args)
        @notifier.notify_sql(
          route: route,
          method: Thread.current[:airbrake_rails_method],
          sql: event.payload[:sql],
          duration: event.duration,
          start_time: event.time,
          end_time: event.end
        )
      end
    end
  end
end
