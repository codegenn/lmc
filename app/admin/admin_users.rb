ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :updated_at
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :name
      f.input :phone
      f.input :address
      f.input :commission
      f.inputs 'Status' do
        f.input :status, as: :boolean, label: 'Active'
      end
      f.input :permission, :as => :select, collection: [['Partner', 1], ['Admin', 2], ['Default', 0]], checked: current_admin_user.permission
    end
    f.actions
  end

end
