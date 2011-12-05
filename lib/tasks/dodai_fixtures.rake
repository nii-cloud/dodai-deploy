namespace :dodai do
  namespace :fixtures do

    desc "Extract data in database to test fixtures."
    task :extract => :environment do
      sql  = "SELECT * FROM %s"
      skip_tables = ["schema_info"]
      ActiveRecord::Base.establish_connection
      (ActiveRecord::Base.connection.tables - skip_tables).each do |table_name|
        i = "000"
        File.open("#{Rails.root.to_s}/test/fixtures/#{table_name}.yml", 'w') do |file|
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
