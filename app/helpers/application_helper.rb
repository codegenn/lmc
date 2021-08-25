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
end
