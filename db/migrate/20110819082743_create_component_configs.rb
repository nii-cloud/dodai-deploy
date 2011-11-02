class CreateComponentConfigs < ActiveRecord::Migration
  def self.up
    create_table :component_configs do |t|
      t.references :proposal
      t.references :component
      t.references :component_config_default
      t.string :content

      t.timestamps
    end
  end

  def self.down
    drop_table :component_configs
  end
end
