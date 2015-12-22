module ROM
  class ContainersFactory

    cattr_reader :entities_root_paths
    attr_reader :gateways_options, :config

    def self.set_entities_root_paths(relations_root_path, mappers_root_path, commands_root_path)
      @@entities_root_paths = {
        relation: Pathname.new(relations_root_path),
        mapper: Pathname.new(mappers_root_path),
        command: Pathname.new(commands_root_path)
      }
    end

    def initialize(gateways_options)
      @gateways_options = gateways_options
      @config = ROM::Configuration.new(@gateways_options)
    end

    def build
      gateway_types.each do |gateway_type|
        register_entities(:relation, entities_root_paths[:relation].join(gateway_type.to_s))
        register_entities(:command, entities_root_paths[:command].join(gateway_type.to_s))
      end
      register_entities(:mapper, entities_root_paths[:mapper])

      ROM.container(config)
    end

    private

    def gateway_types
      @gateway_types ||= gateways_options.values.map(&:first)
    end

    def register_entities(entities_type, entities_path)
      entities_root_path = entities_root_paths[entities_type]
      Dir[entities_path.join('**', '*.rb')].each do |file|
        klass = file.gsub(/#{entities_root_path.dirname}/, '').gsub(/\.rb/, '').camelize.constantize
        config.public_send("register_#{entities_type}", klass)
      end
    end

  end
end
