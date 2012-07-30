class User < ActiveRecord::Base

  has_many :providers

  def self.find_by_provider_id(provider_name, provider_id)
    provider = Provider.find_by_type_and_uid(provider_name, provider_id)
    provider ? provider.user : nil
  end

  def self.create_from_auth(auth_hash)
    create(
      :name => auth_hash[:info][:name],
      :avatar_url => auth_hash[:info][:image],
      :rotation_size => 8,
      :rotation_frequency => 1
    )
  end

  def add_provider_from_auth(auth_hash)
    existing_provider = providers.find_by_type(auth_hash[:provider])
    return existing_provider if existing_provider.present?

    new_provider = providers.build(
      :type => auth_hash[:provider],
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

end