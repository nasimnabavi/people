module ROM
  class ContainersFactory
    cattr_reader :components_root_paths
    attr_reader :gateways_options, :config

    def self.set_components_root_paths(relations_root_path, mappers_root_path, commands_root_path)
      @@components_root_paths = {
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
        register_components(:relation, components_root_paths[:relation].join(gateway_type.to_s))
        register_components(:command, components_root_paths[:command].join(gateway_type.to_s))
      end
      register_components(:mapper, components_root_paths[:mapper])

      ROM.container(config)
    end

    private

    def gateway_types
      @gateway_types ||= gateways_options.values.map(&:first)
    end

    def register_components(components_type, components_path)
      component_root_path = components_root_paths[components_type]
      Dir[components_path.join('**', '*.rb')].each do |file|
        klass = file.gsub(/#{component_root_path.dirname}/, '').gsub(/\.rb/, '').camelize.constantize
        if klass < "ROM::#{components_type.to_s.camelize}".constantize
          config.public_send("register_#{components_type}", klass)
        end
      end
    end
  end
end
