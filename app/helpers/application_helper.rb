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

  def canonical(url)
    content_for(:canonical, tag(:link, rel: :canonical, href: url)) if url
  end

  def breadcrumb(title, url)
    add_breadcrumb title, url
  end
end
