class NodeCandidatesController < ApplicationController
  def index
    respond_to do |format| 
      format.json { 
        candidates = []
        names = McUtils.find_hosts - Node.all.map(&:name)
        names.each {|name|
          candidates << {:name => name, :ip_address => IPSocket.getaddress(name)}
        }
        render :json => JSON.pretty_generate(candidates.as_json)  
      }
    end
  end
end
