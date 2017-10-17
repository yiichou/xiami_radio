module XiamiRadio
  class Notice
    class << self

      def push(msg, expired = 3)
        queue << { content: msg, expired_at: Time.now.to_i + expired }
      end

      def shift
        queue.shift until queue.empty? || queue.first[:expired_at] > Time.now.to_i
        queue.first&.fetch(:content, nil)
      end

      def queue
        @queue ||= []
      end
    end
  end
end