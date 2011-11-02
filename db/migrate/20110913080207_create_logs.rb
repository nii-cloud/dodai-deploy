class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.string :content
      t.string :operation
      t.references :proposal
      t.references :node

      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end
