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


  def list_bread(arr_bread)
    list_items = []
    arr_bread.each_with_index do |v, i|
      list_items.push({
        "@type": "ListItem",
        "position": (i+1).to_i,
        "name": v[:name],
        "item": v[:item]
      })
    end

    @datas = {
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      "itemListElement": list_items
    }.to_json
  end

  def cdn_url
    "https://d1monvl96vvqbd.cloudfront.net"
  end

  def avatar_url(user)
    if user.image
      user.image
    else
      gravatar_id = Digest::MD5::hexdigest(user.email).downcase
      "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=identical&s=150"
    end
  end

  def convert(content)
    regex = /(?:https?:\/\/)?(?:www\.)?(?:youtube\.com|youtu\.be)\/(?:watch\?v=|embed\/)([a-zA-Z0-9_-]{11})/
    match = content.match(regex)
    if match.present?
      youtube_embed_url = "https://www.youtube.com/embed/#{match[1]}"
      iframe = "<iframe class='iframe-youtube' src='#{youtube_embed_url}' frameborder='0' allow='accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture' allowfullscreen></iframe>"
      content.gsub!(match[0], iframe)
    end
  end
end
