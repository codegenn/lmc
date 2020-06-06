ActiveAdmin.register Voucher do
  permit_params :code, :voucher_type, :active

  form do |f|
    inputs do
      input :code
      input :active
      input :voucher_type, as: :select, collection: Voucher::VOUCER_TYPE
      actions
    end
  end
end
