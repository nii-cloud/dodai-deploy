class CreateSoftwareConfigDefaults < ActiveRecord::Migration
  def self.up
    create_table :software_config_defaults do |t|
      t.string :path
      t.string :content
      t.references :software

      t.timestamps
    end
  end

  def self.down
    drop_table :software_config_defaults
  end
end
