class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer :user_id, :null => false
      t.string :first_name, :default => ""
      t.string :last_name, :default => ""
      t.string :gender
      t.date :birthdate
      t.string :occupation, :default => ""
      t.string :city, :default => ""
      t.string :state, :default => ""
      t.string :zipcode, :default => ""
      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
