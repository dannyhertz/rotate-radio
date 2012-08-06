class AddInitialTables < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :avatar
      t.integer :rotation_size
      t.integer :rotation_frequency
      t.timestamps
    end

    create_table :providers do |t|
      t.integer :user_id
      t.string :uid
      t.string :service
      t.string :url
      t.string :username
      t.string :token
      t.string :secret
      t.timestamps
    end
    
    create_table :artists do |t|
      t.string :name
      t.string :rdio_id
      t.string :rdio_url
      t.string :rdio_avatar
      t.string :twitter_id
      t.string :twitter_username
      t.string :twitter_avatar
      t.boolean :verified, :default => false
      t.boolean :flagged, :default => false
      t.date :last_checked
      t.timestamps
    end

    create_table :rotations do |t|
      t.integer :user_id
      t.timestamps
    end

    create_table :artists_rotations, :id => false do |t|
      t.integer :artist_id
      t.integer :rotation_id
    end

    create_table :follow_exceptions do |t|
      t.integer :user_id
      t.integer :artist_id
      t.string :status
      t.timestamps
    end
  end

  def down
    drop_table :providers
    drop_table :users
    drop_table :artists
    drop_table :heavy_rotations
    drop_table :blacklists
  end
end
