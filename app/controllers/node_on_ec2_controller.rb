class NodeOnEc2Controller < ApplicationController
  def index
    @form_values = {}
    UserData.find_all_by_user_id(current_user.id).each{|user_data| @form_values[user_data.key] = user_data.value}
    unless @user_datas
      @form_values['user_data'] = _template
      @form_values['group'] = 'default'
      @form_values['image_id'] = 'ami-7c90277d'
      @form_values['instance_type'] = 'm1.large'
      @form_values['region'] = 'ap-northeast-1'
    end
  end

  def create
    ec2 = RightAws::Ec2.new(params[:access_key], params[:secret_key], :region => params[:region])
    result = ec2.run_instances(params[:image_id], 1, 1, [params[:group]], params[:key], params[:user_data], nil, params[:instance_type])
    node_dns_names = _get_dns_name(ec2, result)
    _add_node(node_dns_names)

    ["access_key", "secret_key", "region", "image_id", "group", "key", "user_data", "instance_type"].each{|key|
      value = params[key]
      user_data = UserData.find_by_user_id_and_key(current_user.id, key)
      unless user_data
        user_data = UserData.new
      end
      user_data.user_id = current_user.id
      user_data.key = key
      user_data.value = value
      user_data.save
    }

    respond_to do |format|
      format.html { redirect_to nodes_url}
    end
  end


  private
  def _template
    server_fqdn = Settings.puppet.server
    token = current_user.authentication_token

    path = File.dirname(__FILE__) + "/../../lib/tasks/templates/dodai_setup_node.sh.erb"
    puts path
    file = open path
    template = ERB.new file.read
    file.close

    template.result(binding)
  end

  def _get_dns_name(ec2, result)
    instance_ids = result.collect{|i| i[:aws_instance_id]}
    loop do
      result = ec2.describe_instances instance_ids
      instance_ids.each_index{|index| puts "  instance[#{instance_ids[index]}]: #{result[index][:aws_state]}"}
      if result.collect{|i| i[:aws_state]}.delete_if{|i| i == "running"}.empty?
        break
      end
      sleep 30
    end

    result.collect{|i| _convert_to_dns_name i[:private_dns_name]}
  end

  def _convert_to_dns_name(ip)
    if ip =~ /^[0-9.]*$/
      public_dns_name = "ip-" + ip.gsub(/\./, "-")
    else
      ip
    end
  end

  def _add_node(node_dns_names)
    node_dns_names.each{|dns_name|
      node = Node.new
      node.name = dns_name
      node.ip = dns_name.gsub("ip-","").gsub("\.#{params[:region]}.compute.internal", "").gsub("-", ".")
      node.state = "available"
      node.user_id = current_user.id
      node_hash = {:ip => node.ip, :name => node.name}
      loop do
        ips = Node.find_all_by_user_id(current_user.id).map(&:ip)
        candidates = McUtils.find_hosts(current_user.authentication_token).select{|node_candidate|
          not ips.include? node_candidate[:ip]
        }
        if candidates.include? node_hash
          break
        end
        sleep 30
      end
      node.save
    }
  end
end
