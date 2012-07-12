class CreateUserData < ActiveRecord::Migration
  def self.up
    create_table :user_data do |t|
      t.references :user
      t.string :key
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :user_data
  end
end
