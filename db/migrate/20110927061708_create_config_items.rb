class CreateConfigItems < ActiveRecord::Migration
  def self.up
    create_table :config_items do |t|
      t.references :config_item_default
      t.references :proposal
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :config_items
  end
end
