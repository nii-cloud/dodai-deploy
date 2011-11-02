class CreateWaitingProposals < ActiveRecord::Migration
  def self.up
    create_table :waiting_proposals do |t|
      t.references :proposal
      t.string :operation

      t.timestamps
    end
  end

  def self.down
    drop_table :waiting_proposals
  end
end
