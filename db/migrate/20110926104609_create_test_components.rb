class CreateTestComponents < ActiveRecord::Migration
  def self.up
    create_table :test_components do |t|
      t.references :software
      t.references :component

      t.timestamps
    end
  end

  def self.down
    drop_table :test_components
  end
end
