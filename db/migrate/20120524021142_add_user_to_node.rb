class AddUserToNode < ActiveRecord::Migration
  def self.up
    change_table :nodes do |t|
      t.references :user
    end
  end

  def self.down
    remove_column :nodes, :user
  end
end
