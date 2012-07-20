require 'timeout'

class NodeOnEc2Controller < ApplicationController
  def index
    @form_values = {}
    UserData.find_all_by_user_id(current_user.id).each{|user_data| @form_values[user_data.key] = user_data.value}

    if @form_values.empty?
      @form_values['instance_count'] = 1
      @form_values['user_data'] = _get_template
      @form_values['group'] = 'default'
      @form_values['image_id'] = 'ami-7c90277d'
      @form_values['instance_type'] = 'm1.large'
      @form_values['region'] = 'ap-northeast-1'
    end

    if params[:error_msg]
      @_errorMsg = params[:error_msg]
    end
  end

  def create
    ec2 = RightAws::Ec2.new(params[:access_key], params[:secret_key], :region => params[:region])
    result = ec2.run_instances(params[:image_id], params[:instance_count], params[:instance_count],
                               params[:group], params[:key], params[:user_data], nil, params[:instance_type])
    node_dns_names = []

    begin
      timeout(180){
        node_dns_names = _get_dns_name(ec2, result)
      }
      timeout(180){
        _add_nodes(node_dns_names)
      }
    rescue Timeout::Error
      errorMsg = "Timeout occurred while adding nodes."
    end

    ["instance_count", "access_key", "secret_key", "region", "image_id", "group", "key", "user_data", "instance_type"].each{|key|
      user_data = UserData.find_by_user_id_and_key(current_user.id, key)
      unless user_data
        user_data = UserData.new
      end
      user_data.user_id = current_user.id
      user_data.key = key
      user_data.value = params[key]
      user_data.save
    }

    respond_to do |format|
      if errorMsg
        format.html { redirect_to :action => "index", :error_msg => errorMsg}
      else
        format.html { redirect_to nodes_url}
      end
    end
  end


  private
  def _get_template
    server_fqdn = Settings.puppet.server
    token = current_user.authentication_token

    path = Rails.root.to_s + "/lib/tasks/templates/dodai_setup_node.sh.erb"
    logger.debug path
    file = open path
    template = ERB.new file.read
    file.close

    template.result(binding)
  end

  def _get_dns_name(ec2, result)
    instance_ids = result.collect{|i| i[:aws_instance_id]}
    loop do
      result = ec2.describe_instances instance_ids
      instance_ids.each_index{|index| logger.debug "  instance[#{instance_ids[index]}]: #{result[index][:aws_state]}"}
      if result.collect{|i| i[:aws_state]}.delete_if{|i| i == "running"}.empty?
        break
      end
      sleep 30
    end
    result.collect{|i| i[:private_dns_name]}
  end

  def _add_nodes(node_dns_names)
    node_dns_names.each{|dns_name|
      node = Node.new
      node.name = dns_name
      node.ip = dns_name.gsub("ip-","").gsub("\.#{params[:region]}.compute.internal", "").gsub("-", ".")
      node.state = "available"
      node.user_id = current_user.id
      node_hash = {:ip => node.ip, :name => node.name}
      loop do
        candidates = McUtils.find_hosts(current_user.authentication_token)
        candidates.each{|hash| logger.debug "#{hash[:ip]}: #{hash[:name]}"}
        if candidates.include? node_hash
          break
        end
        sleep 30
      end
      node.save
    }
  end
end
