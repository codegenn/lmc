# 1) Put 's3' gem in Gemfile.
# 2) Create as3.yml configuration for S3
# 3) Create initializer for as3.yml
# 4) Make "assets" folder inside your bucket
# 5) After running task run "RAILS_ENV=production rake assets:precompile"
# 6) Invoke task by running "rake as3:upload"

namespace :as3 do  
  desc "Uploads compiled assets (public/assets) to Amazone AS3"
  task :upload do
    
    service = S3::Service.new(:access_key_id => "AKIAVOA7O3QTCMF32FCF",
                              :secret_access_key => "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")
    
    bucket = service.buckets.find("lmcation")
    
    # Upload assets
    assets = bucket.objects.find("assets/")
    
    path = "#{Rails.root.to_s}/public"
    files = Dir["#{path}/assets/**/**"].map { |f| f[path.length+1,f.length-path.length] }
    
    files.each do |f|
      if File.file? "#{path}/#{f}" # Only files.
        
        # MIME type (S3 sux at MIME detection)
        mimetype = `file -ib #{path}/#{f}`.gsub(/\n/,"") # if "-ib" does not work on your OS use "-Ib"
        mimetype = mimetype[0,mimetype.index(';')]
        mimetype = "application/javascript" if "#{path}/#{f}" =~ /\.js/
        mimetype = "text/css" if "#{path}/#{f}" =~ /\.css/

        # Don't upload existing
        begin
          existing = bucket.objects.find(f)
          # puts "File: #{f} - Not updated!"       
        rescue => e
          new_object = bucket.objects.build(f)
          new_object.content = open("#{path}/#{f}")
          new_object.content_type = mimetype
          new_object.save      
          new_object.acl.put({ acl: "public-read" })
          puts "File: #{f} - Upload complete."       
        end
      end
    end
    
   puts "Done."
  end
end