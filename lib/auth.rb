require 'jwt'
class Auth
  ALGORITHM = ENV["ALGORITHM"]
  SECRET_KEY = ENV["SPP_SECRET_KEY"]

  def self.issue(payload)
    JWT.encode(
      payload,
      auth_secret,
      ALGORITHM)
  end

  def self.decode(token)
    JWT.decode(token, 
      auth_secret, 
      true, 
      { algorithm: ALGORITHM }).first
  end

  def self.auth_secret
    ENV["AUTH_SECRET"]
  end

  def self.auth_signature(body)
    digest = OpenSSL::Digest.new('sha256')
    hash = OpenSSL::HMAC.digest(digest, SECRET_KEY, body.to_json)
    signature = Base64.encode64(hash)

    signature
  end
end