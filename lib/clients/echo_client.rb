class EchoClient

  attr_accessor :client

  def initialize(client)
    @client = client
  end

  def self.global_init
    client = Nestling.new(RotateRadio::Application.config.creds['echonest']['api_key'])
    new(client)
  end

  def twitter_handle_for_rdio_id(rdio_id)
    echo_artist = @client.artists("rdio-US:artist:#{rdio_id}").profile(:bucket => 'id:twitter')
    return unless echo_artist.has_key?(:foreign_ids)

    twitter_catalog = echo_artist.foreign_ids.detect { |fi| fi['catalog'] == 'twitter' }
    twitter_catalog['foreign_id'].split(':')[2]
  end

end