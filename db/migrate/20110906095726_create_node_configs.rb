class CreateNodeConfigs < ActiveRecord::Migration
  def self.up
    create_table :node_configs do |t|
      t.references :proposal
      t.references :node
      t.references :component
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :node_configs
  end
end
