class CreateVoiceActors < ActiveRecord::Migration
  def self.up
    create_table :voice_actors do |t|
      t.string :name, :null => false
      t.string :kana, :null => false
      t.string :nickname
      t.integer :gender
      t.date :birthday

      t.timestamps
    end
  end

  def self.down
    drop_table :voice_actors
  end
end
