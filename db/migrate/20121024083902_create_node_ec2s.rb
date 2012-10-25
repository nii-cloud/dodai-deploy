class CreateNodeEc2s < ActiveRecord::Migration
  def change
    create_table :node_ec2s do |t|
      t.string :instance_id
      t.integer :user_id

      t.timestamps
    end
  end
end
