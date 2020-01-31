class Foundation < ActiveRecord::Base
  def self.main_page
    foundations = []
    %w(inspiration empowerment blog news).each do |category|
      foundations << Foundation.where(category: category).last(3)
    end
    foundations
  end
end
