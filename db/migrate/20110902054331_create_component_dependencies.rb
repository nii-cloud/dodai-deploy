class CreateComponentDependencies < ActiveRecord::Migration
  def self.up
    create_table :component_dependencies do |t|
      t.references :source_component
      t.references :dest_component
      t.references :software
      t.string :operation

      t.timestamps
    end
  end

  def self.down
    drop_table :component_dependencies
  end
end
