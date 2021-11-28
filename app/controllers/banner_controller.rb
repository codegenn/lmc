class BannerController < ApplicationController
    skip_before_action :verify_authenticity_token
    def show
        
    end

    def upload
        text = ""
        File.open("/workdir/app/assets/images/banner.txt", "r") do |f|
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
            File.open("/workdir/app/assets/images/banner/desktop/desktop.#{type}", "wb") { |f| f.write(params[:filedesktop].read) }
            data[:desktop] = "desktop.#{type}"
        end

        name = params[:filemobile]
        p name
        if name.present?
            type = "jpg" if name.content_type.include?("jpeg")
            type = "png" if name.content_type.include?("png")
            File.open("/workdir/app/assets/images/banner/desktop/mobile.#{type}", "wb") { |f| f.write(params[:filemobile].read) } 
            data[:mobile] = "mobile.#{type}"
        end

        File.open("/workdir/app/assets/images/banner.txt", 'w') { |file| file.write(data) }
        redirect_to "/change-banner"
    end
end