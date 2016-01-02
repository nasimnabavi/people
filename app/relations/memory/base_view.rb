module Relations
  module Memory
    module BaseView
      extend ActiveSupport::Concern

      included do
        use :view
        use :key_inference

        view(:base, sql_relation_columns) do
          self
        end
      end

      module ClassMethods
        def sql_relation_columns
          Rails.application.config.rom_sql_container.relation(relation_name.to_sym).columns
        end

        def relation_name
          self.name.demodulize.underscore
        end
      end
    end
  end
end
