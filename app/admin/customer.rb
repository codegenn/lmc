ActiveAdmin.register User do
    permit_params :email, :password, :password_confirmation
  
    index do
      selectable_column
      id_column
      column :email
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
        f.inputs 'Status' do
          f.input :status, as: :boolean, label: 'Active'
        end
      end
      f.actions
    end
  controller do
    def update
      # Skip password validation during update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
        @user = User.find(params[:id])
        @user.update(status: 1)
        redirect_to admin_users_path, notice: "User updated successfully."
      else
        super
      end
    end
  end
end
  