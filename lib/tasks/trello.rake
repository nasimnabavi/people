namespace :trello do
  desc 'Synchronize board'
  task board_sync: :environment do
    board = Trello::Board.find AppConfig.trello.schedule_board_id
    Trello::BoardSync.new(board).call!
  end
end
