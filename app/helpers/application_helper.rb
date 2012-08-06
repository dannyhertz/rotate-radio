module ApplicationHelper

  def provider_auth_path(provider)
    "/auth/#{provider.to_s}"
  end

end
