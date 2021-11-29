ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

    form action: '/upload-banner', method: 'post', enctype: 'multipart/form-data' do
        input :submit, type: :submit, value: 'Upload'
        label 'Thay đường link'
        input type: 'text', name: 'link'
        label 'Chọn ảnh cho banner desktop'
        input type: 'file', name: 'filedesktop', accept: 'image/jpg, image/jpeg, image/png'
        label 'Chọn ảnh cho banner mobile'
        input type: 'file', name: 'filemobile', accept: 'image/jpg, image/jpeg, image/png'
    end

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
