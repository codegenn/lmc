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

  def meta_data(title, description, image, url, keyword=nil)
    @title = title
    @description = strip_tags(description)
    @image = image
    @url = url
    @keyword = keyword
  end

  def strip_tags(string)
    string.gsub( %r{</?[^>]+?>}, '' )
  end
end
