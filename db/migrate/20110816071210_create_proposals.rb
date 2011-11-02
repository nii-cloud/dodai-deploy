class CreateProposals < ActiveRecord::Migration
  def self.up
    create_table :proposals do |t|
      t.string :name
      t.references :software
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :proposals
  end
end
