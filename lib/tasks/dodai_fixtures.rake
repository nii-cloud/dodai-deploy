namespace :dodai do
  namespace :fixtures do

    desc "Extract data in database to test fixtures."
    task :extract => :environment do
      path = "#{Rails.root.to_s}/test/fixtures"
      Dir::mkdir path unless File.exist? path
      sql  = "SELECT * FROM %s"
      skip_tables = ["schema_info"]
      ActiveRecord::Base.establish_connection
      (ActiveRecord::Base.connection.tables - skip_tables).each do |table_name|
        i = "000"
        File.open("#{path}/#{table_name}.yml", 'w') do |file|
          data = ActiveRecord::Base.connection.select_all(sql % table_name)
          file.write data.inject({}) { |hash, record|
            hash["#{table_name}_#{i.succ!}"] = record
            hash
          }.to_yaml.gsub(/<%/, "<%%")
        end
      end
    end
  end
end
