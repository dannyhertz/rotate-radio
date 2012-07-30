class AddInitialTables < ActiveRecord::Migration
  def up
  	create_table :providers do |t|
      t.integer :user_id
      t.string :uid
  		t.string :type
      t.string :url
      t.string :username
      t.string :token
      t.string :secret
      t.timestamps
  	end

    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :avatar_url
      t.integer :rotation_size
      t.integer :rotation_frequency
      t.timestamps
    end

    create_table :artists do |t|
      t.string :rdio_artist_it
      t.string :twitter_user_id
      t.string :twitter_avatar_url
      t.string :twitter_username
      t.datetime :last_checked
      t.timestamps
    end

    create_table :heavy_rotations do |t|
      t.integer :artist_id
      t.integer :user_id
      t.integer :rank
      t.timestamps
    end

    create_table :blacklists do |t|
      t.integer :user_id
      t.integer :artist_id
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
