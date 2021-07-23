
require 'rubygems'
require 'aws-sdk'

Aws.config.update({
  region: 'us-east-1',
  credentials: Aws::Credentials.new(
    "AKIAVOA7O3QTCMF32FCF", "UmLqZQHtdaDG0rGfeNQaHas64F4glv4SKPwwYJ0E"
  )
})
s3 = Aws::S3::Resource.new
bucket = s3.bucket('lmcation')

ten_year_in_seconds = 10 * 365 * 24 * 60 * 60
ten_year_from_now = Time.now + ten_year_in_seconds

bucket.objects.each do |object_summary|
  location = "#{bucket.name}/#{object_summary.key}"
  # if object_summary.key.include?("categories")
    puts object_summary.key
    type = object_summary.key.split(".")[1]
    options = {
      cache_control: "public, max-age=#{ten_year_in_seconds}",
      content_type: "image/#{type&.include?("png") ? 'png' : 'jpeg'}",
      metadata_directive: 'REPLACE' # options: 'COPY' or 'REPLACE'
    }
    object_summary.copy_to(location, options)
    object_summary.acl.put({ acl: "public-read" })
  # end
end


resp = object.acl.put({ acl: "public-read" })
ucket = s3.bucket(mybucket)
object = bucket.object("product_images/pimages/000/000/375/original/Ao-nguc-day-cheo-Jane-14.jpg")
resp = object.acl.put({ acl: "public-read" })