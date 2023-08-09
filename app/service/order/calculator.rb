class Order
  class Calculator
    attr_accessor :line_items, :voucher_code

    def initialize(options = {})
      self.line_items = options[:line_items]
      self.voucher_code = options[:voucher_code]
    end

    def total_price
      line_items.joins(:stock).map do |line|
        price = line.stock.product_promotion_price.present? ? line.stock.product_promotion_price : line.stock.product_price
        price * line.quantity
      end.inject(0, :+)
    end

    def order_total_price
      line_items.map { |line| line.price.to_i * line.quantity }.inject(0, :+)
    end

    def total_products
      line_items.sum('line_items.quantity')
    end

    def calculate_grand_total(cart)
      discount = Voucher.where(code: self.voucher_code, active: true).first
      if discount.present?
        if discount.voucher_type == '50 off'
          total = cart.total_price
          total = total - (total * 50 / 100)
        elsif discount.voucher_type == '30 off'
          total = cart.total_price
          total = total - (total * 30 / 100)
        elsif discount.voucher_type == '40 off'
          total = cart.total_price
          total = total - (total * 40 / 100)
        elsif discount.voucher_type == '45 off'
          total = cart.total_price
          total = total - (total * 45 / 100)
        elsif discount.voucher_type == '55 off'
          total = cart.total_price
          total = total - (total * 55 / 100)
        elsif discount.voucher_type == '60 off'
          total = cart.total_price
          total = total - (total * 60 / 100)
        elsif discount.voucher_type == '70 off'
          total = cart.total_price
          total = total - (total * 70 / 100)
        elsif discount.voucher_type == 'Buy 1 get 1 free'
          total = 0
          counting = 1
          cart.line_items.joins(:stock).sort_by do |obj|
            obj.stock.product_promotion_price.present? ? -obj.stock.product_promotion_price : -obj.stock.product_price
          end.map do |line|
            line.quantity.times do
              if counting % 2 == 1
                total += line.stock.product_promotion_price.present? ? line.stock.product_promotion_price : line.stock.product_price
              end
              counting += 1
            end
          end
        elsif discount.voucher_type == '199k'
          total = cart.line_items.sum('line_items.quantity') * 199000
        elsif discount.voucher_type == '299k'
          
          total = cart.line_items.sum('line_items.quantity') * 299000
        elsif discount.voucher_type == 'v200'
          total = cart.total_price
          total = total - 200000
          total = 0 if total < 0
        elsif discount.voucher_type == 'v100'
          total = cart.total_price
          total = total - 100000
          total = 0 if total < 0
        elsif discount.voucher_type == 'v40'
          total = cart.total_price
          total = total - 40000
          total = 0 if total < 0
        elsif discount.voucher_type == '99k'
          total = cart.line_items.sum('line_items.quantity') * 99000
        end
      else
        total = cart.total_price
      end
      total
    end
  end
end
