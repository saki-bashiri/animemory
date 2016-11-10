class RefactoringCreators < ActiveRecord::Migration
  def up
    drop_table :creators
    create_table :creators do |t|
      t.string :name, :null => false
      t.string :kana
      t.text :description
      t.boolean :staff_flg, :null => false, :default => false
      t.boolean :production_flg, :null => false, :default => false
      t.boolean :unit_flg, :null => false, :default => false
      t.boolean :voice_actor_flg, :null => false, :default => false
      t.boolean :singer_flg, :null => false, :default => false
      t.boolean :songwriter_flg, :null => false, :default => false
      t.boolean :composer_flg, :null => false, :default => false
      t.timestamps
    end

    add_index :creators, :name, "name" => "unique_name", :unique => true
    add_index :creators, :staff_flg, :name => "staff_flg"
    add_index :creators, :production_flg, :name => "production_flg"
    add_index :creators, :unit_flg, :name => "unit_flg"
    add_index :creators, :voice_actor_flg, :name => "voice_actor_flg"
    add_index :creators, :singer_flg, :name => "singer_flg"
    add_index :creators, :songwriter_flg, :name => "songwriter_flg"
    add_index :creators, :composer_flg, :name => "composer_flg"

    add_column :characters, :creator_id, :integer, :null => false, :default => 0, :after => :artist_id
    add_column :song_artists, :creator_id, :integer, :null => false, :default => 0, :after => :artist_id
    add_column :units, :creator_id, :integer, :null => false, :default => 0, :after => :artist_id
    change_column :characters, :artist_id, :integer, :null => true, :after => :anime_id
    change_column :song_artists, :artist_id, :integer, :null => true, :after => :song_id
    change_column :units, :artist_id, :integer, :null => true, :after => :unit_id

    create_table :my_channels do |t|
      t.integer :user_id, :null => false
      t.integer :creator_id, :null => false
    end

    add_index :my_channels, [:user_id, :creator_id], :name => "user_creator_id", :unique => true
    add_index :my_channels, :creator_id, :name => "creator_id"

    create_table :channel_notifications do |t|
      t.integer :creator_id, :null => false
      t.integer :anime_id, :null => false
      t.integer :staff_id
      t.integer :song_artist_id
      t.integer :character_id
      t.datetime :created_at, :null => false
    end

    add_index :channel_notifications, :creator_id, :name => "creator_id"
    add_index :channel_notifications, :anime_id, :name => "anime_id"
    add_index :channel_notifications, :staff_id, :name => "staff_id"
    add_index :channel_notifications, :song_artist_id, :name => "song_artist_id"
    add_index :channel_notifications, :character_id, :name => "character_id"
    add_index :channel_notifications, :created_at, :name => "created_at"

    create_table :read_channel_notifications do |t|
      t.integer :user_id, :null => false
      t.integer :channel_notification_id, :null => false
    end

    add_index :read_channel_notifications, :user_id, :name => "user_id"
    add_index :read_channel_notifications, :channel_notification_id, :name => "channel_notification_id"
  end

  def down
  end
end
