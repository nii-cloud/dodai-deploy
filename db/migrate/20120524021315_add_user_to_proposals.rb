class AddUserToProposals < ActiveRecord::Migration
  def self.up
    change_table :proposals do |t|
      t.references :user
    end
  end

  def self.down
    remove_column :proposals, :user
  end
end
