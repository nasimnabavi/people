shared_context 'rom sql container context' do
  before { @rom_container = Rails.application.config.rom_sql_container }
end
