class Favorite < ActiveRecord::Base
  has_many :favorite_products, dependent: :destroy
  has_many :products, through: :favorite_products
  belongs_to :user
  before_create :set_fav_code

  private
  def set_fav_code
    self.code = Devise.friendly_token
  end
end
