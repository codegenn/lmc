class Order
  class Calculator
    attr_accessor :line_items

    def initialize(options = {})
      self.line_items = options[:line_items]
    end

    def total_price
      line_items.joins(:stock).map { |line| line.stock.product_price * line.quantity }.inject(0, :+)
    end

    def total_products
      line_items.sum('line_items.quantity')
    end
  end
end
