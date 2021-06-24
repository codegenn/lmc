module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def meta_data(title, description, image, url)
    @title = title
    @description = description
    @image = image
    @url = url
  end
end
