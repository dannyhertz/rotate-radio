class User < ActiveRecord::Base

  attr_accessible :name, :avatar, :rotation_size, :rotation_frequency, :rotation_status

  has_many :providers
  has_many :rotations
  has_many :follow_exceptions
  has_many :blacklist_artists, :through => :follow_exceptions, :source => :artist, :conditions => { 'follow_exceptions.status' => 'black' }
  has_many :whitelist_artists, :through => :follow_exceptions, :source => :artist, :conditions => { 'follow_exceptions.status' => 'white' }

  def self.find_by_provider_auth(auth_hash)
    provider = Provider.find_by_service_and_uid(auth_hash[:provider], auth_hash[:uid])
    provider ? provider.user : nil
  end

  def self.create_from_provider_auth(auth_hash)
    create(
      :name => auth_hash[:info][:name],
      :avatar => auth_hash[:info][:image],
      :rotation_size => 8,
      :rotation_frequency => 1
    )
  end

  def add_provider_from_auth(auth_hash)
    existing_provider = providers.find_by_service(auth_hash[:provider])
    return existing_provider if existing_provider.present?

    new_provider = providers.build(
      :service => auth_hash[:provider],
      :uid => auth_hash[:uid],
      :username => auth_hash[:info][:nickname],
      :token => auth_hash[:credentials][:token],
      :secret => auth_hash[:credentials][:secret]
    )

    if auth_hash[:provider] == 'twitter'
      new_provider.url = auth_hash[:info][:urls][:Twitter]
    else
      new_provider.url = auth_hash[:info][:urls][:User]
    end

    new_provider.save
  end

  def fully_authed?
    providers.for_service(:rdio).present? && providers.for_service(:twitter).present?
  end

  def whitelist!(artist)
    artist = Artist.find_by_id(artist) if artist.is_a?(Numeric)
    follow_exceptions.create(:artist => artist, :status => 'white') unless has_whitelisted?(artist)
  end

  def blacklist!(artist)
    artist = Artist.find_by_id(artist) if artist.is_a?(Numeric)
    follow_exceptions.create(:artist => artist, :status => 'black') unless has_blacklisted?(artist)
  end

  def has_blacklisted?(artist)
    blacklist_artists.include?(artist)
  end

  def has_whitelisted?(artist)
    whitelist_artists.include?(artist)
  end

  def service_provider(service)
    providers.for_service(service).first
  end

  def follow_rotation!(rotation)
    previous_artists = rotation.previous ? rotation.previous.artists : []
    next_artists = rotation.artists

    new_artists = next_artists - previous_artists

    new_artists.each do |a|
      if twitter_client.following?(:target_user => a.twitter_id)
        whitelist!(a)
      end
      
      twitter_client.follow!(a.twitter_id) unless has_blacklisted?(a)
    end
  end

  def unfollow_rotation!(rotation)
    unfollows = rotation.artists - whitelist_artists
    twitter_client.unfollow!(unfollows.map(&:twitter_id))
  end

  def adjust_following!(rotation)
    previous_artists = rotation.previous ? rotation.previous.artists : []
    
    new_artists = rotation.artists - previous_artists - blacklist_artist_ids
    remove_artists = previous_artists - rotation.artists - whitelist_artist_ids

    new_twitter_artists = new_artists.select { |a| a.twitter_id }
    remove_twitter_artists = remove_artists.select { |a| a.twitter_id }

    # unfollow old artists
    twitter_client.unfollow!(remove_twitter_artists.map(&:twitter_id))

    # follow new artists
    new_twitter_artists.each do |a|
      whitelist!(a) if twitter_client.following?(:target_user => a.twitter_id)
      twitter_client.follow!(a.twitter_id)
    end
  end

  def refresh_rotation(options = {})
    options = options.reverse_merge({
      :limit => 10
    })

    rotation_results = rdio_client.heavy_rotation(options)
    return unless rotation_results

    previous_rotation = rotations.last
    next_rotation = Rotation.build_from_rdio_rotation(rotation_results)

    if previous_rotation && previous_rotation.has_identical_artists?(next_rotation)
      nil
    else
      adjust_following!(next_rotation)
      rotations << next_rotation
      next_rotation
    end
  end

  def active_rotation?
    rotation_status == 1
  end

  protected

  def rdio_client
    @rdio_client ||= RdioClient.user_init(self)
  end

  def twitter_client
    @twitter_client ||= TwitterClient.user_init(self)
  end

end