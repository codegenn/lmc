class BannerController < ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token
    def show
        
    end

    def upload
        text = ""
        File.open("app/assets/images/banner.txt", "r") do |f|
            f.each_line do |line|
                text += line
            end
        end
        data = eval(text)
        p data

        link = params[:link]
        data[:Link] = link if link.present?

        name = params[:filedesktop]
        p name
        if name.present?
            type = "jpg" if name.content_type.include?("jpeg")
            type = "png" if name.content_type.include?("png")
            File.open("app/assets/images/banner/desktop/desktop.#{type}", "wb") { |f| f.write(params[:filedesktop].read) }
            data[:desktop] = "desktop.#{type}"
        end

        name = params[:filemobile]
        p name
        if name.present?
            type = "jpg" if name.content_type.include?("jpeg")
            type = "png" if name.content_type.include?("png")
            File.open("app/assets/images/banner/mobile/mobile.#{type}", "wb") { |f| f.write(params[:filemobile].read) } 
            data[:mobile] = "mobile.#{type}"
        end

        File.open("app/assets/images/banner.txt", 'w') { |file| file.write(data) }
        redirect_to "/admin/banner?locale=vi"
    end
end