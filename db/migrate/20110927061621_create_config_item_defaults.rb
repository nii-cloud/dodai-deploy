class CreateConfigItemDefaults < ActiveRecord::Migration
  def self.up
    create_table :config_item_defaults do |t|
      t.references :software
      t.string :name
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :config_item_defaults
  end
end
