class Stock < ActiveRecord::Base
  belongs_to :product
  validates :size, :color, presence: true
  delegate :title, :price, :promotion_price, to: :product, prefix: true

  def self.sync_kiot_quantity
    all.each do |product|
      update_quantity(product, token_kiot)
    end
  end

  def self.update_quantity(product, token)
    id = product.product_code.split[0]
    puts "======================id: #{id} \n"
    repo = KiotViet.get_product(token, id)
    if repo.code == 200
      data = JSON.parse(repo.body)
      id = data["inventories"].last["productId"]
      quantity = data["inventories"].last["onHand"]
      puts "======================kiot: #{quantity} \n"
      puts "======================store #{product.quantity} \n"
      if quantity.present? && quantity != product.quantity
        Stock.transaction do
          product.update(quantity: quantity)
          product.save
        end
      end
    end
  end

  def self.token_kiot
    KiotViet.configure do |config|
      config.client_id = ENV['KIOT_CLIENT_ID']
      config.client_secret = ENV['KIOT_CLIENT_SECRET']
    end
    respon = KiotViet.get_token
    token = respon["access_token"]

    "Bearer ".concat(token)
  end
end
