ActiveAdmin.register Application do
  permit_params :name, :email, :phone_number, :cv
  action_item only: [:show] do
    link_to('Download CV', download_admin_application_path(resource)) if resource.cv.present?
  end

  member_action :download, method: :get do
    application = Application.find(params[:id])
    send_file application.cv.path
  end
end
