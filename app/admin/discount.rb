ActiveAdmin.register_page "Discount" do
  menu priority: 1, label: proc{ "Discount" }
  require 'json'

  controller do
    skip_before_action :verify_authenticity_token
  end

  page_action :change_discount, method: :post do
    data = {}
    data["text"] = params["text"] if params["text"].present?
    data["discount"] = params["amount"] if params["amount"].present?
    File.open("app/assets/file/discount_config.txt", "w") { |f| f.write data.to_json }
    redirect_to "/admin/discount"
  end

  content do
    # Read and parse the existing data from the file
    file_path = "app/assets/file/discount_config.txt"
    if File.exist?(file_path)
      file_content = File.read(file_path)
      existing_data = JSON.parse(file_content) rescue {}
    else
      existing_data = {}
    end

    form action: "discount/change_discount", method: :post do |f|
      f.input :text, type: :text, name: 'text', style: "margin-bottom: 10px", placeholder: "Display text", value: existing_data["text"]
      f.input :amount, type: :number, min: 0, name: 'amount', placeholder: "Discount amount", value: existing_data["discount"]
      f.input :submit, type: :submit, value: "Submit"
    end
  end
end
