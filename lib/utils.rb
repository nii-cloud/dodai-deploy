class Utils
  def self.delete_template_from_puppet(proposal_id)
    FileUtils.remove_dir "#{Settings.puppet.etc}/templates/#{proposal_id.to_s}", true
  end
end
