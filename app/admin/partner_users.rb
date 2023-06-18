ActiveAdmin.register PartnerUser do
  permit_params :email, :password, :password_confirmation, :commission

  index do
    selectable_column
    id_column
    column :email
    column :updated_at
    column :created_at
    column :commision
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
      f.input :commision
    end
    f.actions
  end

  before_action :remove_password_params_if_blank, only: [:update]
  controller do
    def remove_password_params_if_blank
      # Skip password validation during update
      if params[:partner_user][:password].blank? && params[:partner_user][:password_confirmation].blank?
        params[:partner_user].delete(:password)
        params[:partner_user].delete(:password_confirmation)
        @partner_user = PartnerUser.find(params[:id])
        @partner_user.update(commision: params[:partner_user][:commision])
        redirect_to admin_partner_users_path, notice: "User updated successfully."
      else
        super
      end
    end
  end
end
