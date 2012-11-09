namespace :dodai do
  namespace :softwares do

    def load_data_yml(path)
      base_path = File.dirname path
      data = YAML.load_file path
      name = File.basename(File.dirname(path))

      desc = data["description"]
      os = data.fetch "os", "Ubuntu"
      desc += " - " + os

      data.delete "description"
      data.delete "os"

      puts ""
      puts "---------------------------------------------"
      puts "-------Load data for software #{name}.-------"
      puts "---------------------------------------------"
      puts "Add a record to softwares table."

      software = Software.new(:name => name, :desc => desc, :os => os)
      check_save_result software.save, software
      software = Software.find_by_name name

      #move components to the first
      table_names = data.keys
      table_names.delete "components"
      table_names.unshift "components"

      table_names.each {|table_name|
        records = data[table_name]
        cls_name = table_name.classify

        next unless records

        records.each{|record|
          obj = eval(cls_name).new
          record.each{|field_name, field_value|
            if field_name =~ /component/
              eval("obj.#{field_name} = Component.find_by_name_and_software_id field_value, software.id")
              next
            end

            eval("obj.#{field_name} = field_value")
          }

          if cls_name =~ /ConfigDefault/
              file_name = File.basename obj.path
              file = open "#{base_path}/templates/#{file_name}.erb"
              obj.content = file.read
              file.close
          end

          obj.software = software if cls_name != "ComponentConfigDefault"
          check_save_result obj.save, obj

          puts "Add a record to #{table_name} table."
        }
      }
    end

    def check_save_result(result, obj)
      unless result
        puts "Failed"
        p obj
        p obj.errors
      end
    end

    def load_puppet(path, software_name, proxy)
      puts ""
      puts "------------------------------------------------"
      puts "-------Load puppet files for software #{software_name}.--"
      puts "------------------------------------------------"

      dest_path = "/etc/puppet/modules/#{software_name}"
      puts `mkdir -v -p #{dest_path}` unless File.exist? dest_path

      puts `cp -v -r #{path}/* #{dest_path}`
      puppet_init = "#{path}/../puppet-init.sh"

      return unless File.exist? puppet_init

      if proxy == ""
        puts `#{puppet_init} 2>&1`
      else
        puts `https_proxy=#{proxy} http_proxy=#{proxy} #{puppet_init} 2>&1`
      end
    end

    desc "Create scaffold for a software." 
    task :create do
      name = ENV.fetch "name", ""
      if name == ""
        puts <<EOF
Usage: rake dodai:softwares:create name=NAME 

NAME: the name of software.
EOF
        break
      end

      current_path = File.dirname(__FILE__)
      path = current_path + "/../../softwares"
      ["mkdir #{path}/#{name}",
       "mkdir #{path}/#{name}/puppet",
       "mkdir #{path}/#{name}/puppet/files",
       "mkdir #{path}/#{name}/puppet/lib",
       "mkdir #{path}/#{name}/puppet/manifests",
       "mkdir #{path}/#{name}/puppet/templates",
       "mkdir #{path}/#{name}/puppet/tests",
       "echo \"class #{name}{}\" > #{path}/#{name}/puppet/manifests/init.pp",
       "cp #{current_path}/templates/data.yml  #{path}/#{name}/data.yml",
       "mkdir #{path}/#{name}/templates"].each{|cmd|
        puts cmd
        `#{cmd}`
      }
    end

    desc "Load settings of softwares into a database and puppet."
    task :load_all => :environment do
      proxy = ENV.fetch "proxy_server", ""

      base_path = File.dirname(__FILE__) + "/../../softwares"
      path_pattern = base_path + "/*"
      Dir::glob(path_pattern).each {|path|
        load_puppet path + "/puppet", File.basename(path), proxy
        load_data_yml path + "/data.yml"
      }
    end

    desc "Load settings of a software into a database and puppet."
    task :load => :environment do
      name = ENV.fetch "name", ""
      proxy = ENV.fetch "proxy_server", ""
      if name == ""
        puts <<EOF
Usage: rake dodai:softwares:load name=NAME [proxy_server=PROXY_SERVER]

NAME: the name of software.
PROXY_SERVER: the proxy server. It's optional.
EOF
        break
      end

      load_puppet  "#{File.dirname(__FILE__)}/../../softwares/#{name}/puppet" , name, proxy
      load_data_yml "#{File.dirname(__FILE__)}/../../softwares/#{name}/data.yml"
    end

    def unload_data(name)
      Software.find_by_name(name).destroy
    end

    def unload_puppet(name)
      `rm -rf /etc/puppet/modules/#{name}`
    end

    desc "Remove records of a software from database and manifests from puppet."
    task :unload => :environment do
      name = ENV.fetch "name", ""
      proxy = ENV.fetch "proxy_server", ""
      if name == ""
        puts <<EOF
Usage: rake dodai:softwares:unload name=NAME

NAME: the name of software.
EOF
        break
      end

      unload_puppet name
      unload_data name

      "Software #{name} is unloaded."
    end

    desc "List softwares."
    task :list => :environment do
      Software.all.each {|software|
        puts "#{software.name}\t\t#{software.desc}"
      }
    end
  end
end
