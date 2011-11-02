class CreateComponentConfigDefaults < ActiveRecord::Migration
  def self.up
    create_table :component_config_defaults do |t|
      t.string :path
      t.string :content
      t.references :component

      t.timestamps
    end
  end

  def self.down
    drop_table :component_config_defaults
  end
end
