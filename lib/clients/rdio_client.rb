class RdioClient

  attr_accessor :client

  def initialize(client, user = nil)
    @client = client
    @user = user
  end

  def self.user_init(user)
    client = Rdio.new(
      [
        RotateRadio::Application.config.creds['rdio']['consumer_key'], 
        RotateRadio::Application.config.creds['rdio']['consumer_secret']
      ],
      [
        user.service_provider(:rdio).token,
        user.service_provider(:rdio).secret
      ]
    )
    new(client, user)
  end

  def self.global_init
    client = Rdio.new(
      [
        RotateRadio::Application.config.creds['rdio']['consumer_key'], 
        RotateRadio::Application.config.creds['rdio']['consumer_secret']
      ]
    )
    new(client)
  end

  def heavy_rotation(options = {})
    options = options.reverse_merge({
      :user => @user ? @user.service_provider(:rdio).uid : nil,
      :start => 0,
      :limit => 10,
      :type => 'albums'
    })

    response = @client.call('getHeavyRotation', options)
    if response['status'] == 'ok'
      response['result']
    else
      Rails.logger.warn "Error with Rdio call: #{response['message']}"
      nil
    end
  end
end