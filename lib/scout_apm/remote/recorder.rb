module ScoutApm
  module Remote
    class Recorder
      attr_reader :logger
      attr_reader :remote_host
      attr_reader :remote_port

      def initialize(remote_host, remote_port, logger)
        @remote_host = remote_host
        @remote_port = remote_port
        @logger = logger
      end

      def start
        # nothing to do
        self
      end

      def stop
        # nothing to do
      end

      def record!(request)
        # Mark this request as recorded, so the next lookup on this thread, it
        # can be recreated
        request.recorded!

        # Only send requests that we actually want. Incidental http &
        # background thread stuff can just be dropped
        unless request.job? || request.web?
          return
        end

        request.prepare_to_dump!
        message = ScoutApm::Remote::Message.new('record', 'record!', request)
        encoded = message.encode
        logger.debug "Remote Agent: Posting a message of length: #{encoded.length}"
        post(encoded)
      rescue => e
        logger.debug "Remote: Error while sending to collector: #{e.inspect}, #{e.backtrace.join("\n")}"
      end

      def post(encoded_message)
        http = Net::HTTP.new(remote_host, remote_port)
        request = Net::HTTP::Post.new("/users")
        request.body = encoded_message
        response = http.request(request)
      end
    end
  end
end
