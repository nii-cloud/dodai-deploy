require "node"
require "node_config"
require "component"

class ScheduleCache
  def self.write(proposal_id, operation, data)
    Rails.cache.write self._get_key(proposal_id, operation), Marshal.dump(data)
  end

  def self.read(proposal_id, operation)
    Marshal.load Rails.cache.read self._get_key(proposal_id, operation)
  end

  def self.exist?(proposal_id, operation)
    Rails.cache.exist? self._get_key(proposal_id, operation)
  end

  def self.delete(proposal_id, operation)
    Rails.cache.delete self._get_key(proposal_id, operation)
  end 

  private

  def self._get_key(proposal_id, operation)
    "/schedules/#{proposal_id}_#{operation}"
  end
end
