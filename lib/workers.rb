class Workers
  @@logger = Rails.logger 

  def self.create
    t = Thread.new do
      @@logger.debug "Start thread"
      success = true
      begin 
        success = yield :start
      rescue => exc
        @@logger.debug exc.inspect
        @@logger.debug exc.backtrace.join "\n"
        yield :failed
      else
        if success
          yield :succeeded
        else
          yield :failed
        end
      end
      @@logger.debug "End thread"
    end
  end
end
