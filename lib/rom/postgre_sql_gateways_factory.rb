module ROM
  class PostgreSqlGatewaysFactory
    class << self

      attr_reader :config

      def build_from_active_record_config(config)
        @config = config.symbolize_keys
        [:sql, connection_url, options]
      end

      private

      def connection_url
        Addressable::URI.new(
          scheme: 'postgres',
          user: config[:username],
          password: config[:password],
          host: config.fetch(:host, ''),
          port: config[:port],
          path: config[:database]
        ).to_s
      end

      def options
        {
          encoding: config[:encoding],
          pool: config[:pool]
        }
      end

    end
  end
end
