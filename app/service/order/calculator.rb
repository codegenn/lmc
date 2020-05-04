class Order
  class Calculator
    attr_accessor :line_items

    def initialize(options = {})
      self.line_items = options[:line_items]
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
  end
end
