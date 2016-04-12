class RefreshAllFeedsJob < ActiveJob::Base
  queue_as :default

  def perform
    puts "START: Queueing Full Feed Refresh"

    Feed.find_each do |feed|
      begin
        feed.refresh_later!
      rescue
        puts "Unable to queue feed refresh job for ID: #{feed.id}"
      end
    end

    puts "DONE: Queueing Full Feed Refresh"
  end
end
