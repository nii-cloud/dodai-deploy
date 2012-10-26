require 'timeout'
require "thread"

class NodeOnEc2Controller < ApplicationController
  def index
    @user_datas = {}
    @instances = [] 
    @_errorMsg = nil
    UserData.find_all_by_user_id(current_user.id).each{|user_data| @user_datas[user_data.key] = user_data.value}

    unless @user_datas.empty?
      ec2 = _connect_ec2 @user_datas 

      instance_ids = NodeEc2.find_all_by_user_id(current_user.id).map(&:instance_id)
      logger.debug instance_ids

      begin
        @instances = ec2.describe_instances instance_ids if instance_ids.size != 0 
      rescue
        @_errorMsg = "Can't connect to Amazon EC2"
      end

      @instances.each{|instance|
        if Node.find_by_user_id_and_name(current_user.id, instance[:private_dns_name])
          instance[:node_state] = "available"
        else 
          case instance[:aws_state]
          when "running"
            instance[:node_state] = "installing"
          when "pending"
            instance[:node_state] = "waiting"
          when "shutting-down"
            instance[:node_state] = "deleted"
          when "terminated"
            instance[:node_state] = "deleted"
          end
        end
      }
    end

    if params[:error_msg]
      @_errorMsg = params[:error_msg]
    end

    respond_to do |format|
      format.html
      format.json do
        render :json => @instances  
      end
    end 
  end

  def new
    @form_values = {
      "instance_count" => 1,
      "user_data" => _get_template,
      "group" => "default",
      "image_id" => "ami-c641f2c7",
      "instance_type" => "m1.small",
      "region" => "ap-northeast-1",
      "endpoint_url" => ""
    }

    UserData.find_all_by_user_id(current_user.id).each{|user_data| @form_values[user_data.key] = user_data.value}

    if params[:error_msg]
      @_errorMsg = params[:error_msg]
    end
  end

  def create
    @_errorMsg = nil
    result = nil

    ec2 = _connect_ec2 params 
    
    begin
      result = ec2.run_instances(params[:image_id], params[:instance_count], params[:instance_count],
                                 params[:group], params[:key], params[:user_data], nil, params[:instance_type])
    rescue Exception
      result = nil
      @_errorMsg = "Can't connect to Amazon EC2"
    end

    if result
      node_dns_names = []
      Thread.start{
        begin
          timeout(180){
            node_dns_names = _get_dns_names(ec2, result)
          }
          timeout(300){
            _add_nodes(node_dns_names)
          }
        rescue Timeout::Error
          logger.debug "Timeout occurred while adding nodes."
        end
      }

      ["instance_count", "access_key", "secret_key", "region", "image_id",
        "group", "key", "user_data", "instance_type", "endpoint_url"].each{|key|

        user_data = UserData.find_by_user_id_and_key(current_user.id, key)
        unless user_data
          user_data = UserData.new
        end
        user_data.user_id = current_user.id
        user_data.key = key
        user_data.value = params[key]
        user_data.save
      }

      result.each{|instance|
        node_ec2 = NodeEc2.new
        node_ec2.instance_id = instance[:aws_instance_id]
        node_ec2.user_id = current_user.id
        node_ec2.save
      }
    end

    respond_to do |format|
      if @_errorMsg
        format.html { redirect_to :action => "new", :error_msg => @_errorMsg}
      else
        format.html { redirect_to node_on_ec2_index_url}
      end
    end
  end

  def terminate
    @_errorMsg = nil
    instance = nil

    node_ec2 = NodeEc2.find_by_user_id_and_instance_id current_user.id, params[:instance_id]
    node_ec2.destroy if node_ec2

    user_datas = {}
    UserData.find_all_by_user_id(current_user.id).each{|user_data| user_datas[user_data.key] = user_data.value}
    ec2 = _connect_ec2 user_datas

    begin
      instance = ec2.describe_instances params[:instance_id]
    rescue
      instance = nil
      @_errorMsg = "Can't connect to Amazon EC2"
    end

    if instance
      node = Node.find_by_name(instance[0][:private_dns_name])

      unless node
        ec2.terminate_instances(params[:instance_id])
      else
        if node.user_id == current_user.id
          if node.node_configs.find(:first)
            errorMsg = "Added proposals must be destroyed first."
          elsif node.destroy
            `puppetca --clean #{current_user.authentication_token}_#{node.name}`
            ec2.terminate_instances(params[:instance_id])
          end
        else
          @_errorMsg = "You don't have permission or the node does not exist."
        end
      end
    end

    respond_to do |format|
      if @_errorMsg
        format.html { render :action => "index"}
      else
        format.html { redirect_to :action => "index"}
      end
    end

  end

  private
  def _connect_ec2(data)
    if data["endpoint_url"] == ""
      ec2 = RightAws::Ec2.new(data["access_key"], data["secret_key"], :region => data["region"])
    else
      ec2 = RightAws::Ec2.new(data["access_key"], data["secret_key"], :endpoint_url => data["endpoint_url"])
    end
  end

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

  def _get_dns_names(ec2, result)
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
