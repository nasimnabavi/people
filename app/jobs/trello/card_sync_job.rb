module Trello
  class CardSyncJob
    include SuckerPunch::Job

    def perform(card)
      CardSync.new(card).call!
    end
  end
end
