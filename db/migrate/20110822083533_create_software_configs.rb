class CreateSoftwareConfigs < ActiveRecord::Migration
  def self.up
    create_table :software_configs do |t|
      t.references :software_config_default
      t.references :software
      t.references :proposal
      t.string :content

      t.timestamps
    end
  end

  def self.down
    drop_table :software_configs
  end
end
