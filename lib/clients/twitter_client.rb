class TwitterClient

  attr_accessor :client

  def initialize(client, user = nil)
    @client = client
    @user = user
  end

  def self.user_init(user)
    client = Twitter.configure do |config|
      config.consumer_key = RotateRadio::Application.config.creds['twitter']['consumer_key']
      config.consumer_secret = RotateRadio::Application.config.creds['twitter']['consumer_secret']
      config.oauth_token = user.service_provider(:twitter).token
      config.oauth_token_secret = user.service_provider(:twitter).secret
    end
    new(client, user)
  end

  def self.global_init
    client = Twitter.configure do |config|      
      config.consumer_key = RotateRadio::Application.config.creds['twitter']['consumer_key']
      config.consumer_secret = RotateRadio::Application.config.creds['twitter']['consumer_secret']
      config.oauth_token = RotateRadio::Application.config.creds['twitter']['token']
      config.oauth_token_secret = RotateRadio::Application.config.creds['twitter']['token_secret']    
    end
    new(client)
  end

  def find_user(identifier)
    @client.user(identifier)
  end

  def following?(options = {})
    options = options.reverse_merge({
      :source_user => @user ? @user.service_provider(:twitter).uid.to_i : nil
    })

    relationship = @client.friendship(options[:source_user], options[:target_user])
    relationship.source.following?
  end

  def follow!(identifiers)
    @client.follow(identifiers)
  end

  def unfollow!(identifiers)
    @client.unfollow(identifiers)
  end

end