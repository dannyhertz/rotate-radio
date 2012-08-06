class Artist < ActiveRecord::Base

  attr_accessible :name, :rdio_id, :rdio_url, :rdio_avatar, :last_checked, :twitter_username, :twitter_id, :twitter_avatar, :verified

  has_and_belongs_to_many :rotations
  has_many :follow_exceptions

  def self.find_or_create_from_rdio(rdio_response)
    existing_artist = find_by_rdio_id(rdio_response['key'])
    return existing_artist if existing_artist

    artist_attrs = {
      :name => rdio_response['name'],
      :rdio_id => rdio_response['key'],
      :rdio_url => rdio_response['shortUrl'],
      :rdio_avatar => rdio_response['icon'],
      :last_checked => Date.today
    }

    # grab verified twitter info from echo
    echo_client = EchoClient.global_init
    twitter_handle = echo_client.twitter_handle_for_rdio_id(rdio_response['key'])

    # merge twitter attrs if we got their info
    if twitter_handle
      twitter_client = TwitterClient.global_init
      twitter_user = twitter_client.find_user(twitter_handle)

      artist_attrs.merge!({
        :twitter_username => twitter_user.screen_name,
        :twitter_id => twitter_user.id,
        :twitter_avatar => twitter_user.profile_image_url(:original),
        :verified => true
      })
    end

    create(artist_attrs)
  end

  def twitter_id
    id = read_attribute(:twitter_id)
    id ? id.to_i : nil
  end

end