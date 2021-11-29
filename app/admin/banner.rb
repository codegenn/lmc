ActiveAdmin.register_page "Banner" do
    content do
        form action: '/upload-banner', method: 'post', enctype: 'multipart/form-data' do
            table class: "index_table index" do
                tr do
                    td do
                        input :submit, type: :submit, value: 'Upload'
                    end
                end
                tr do
                    td do
                        label 'Thay đường link'
                    end
                    td do
                        input type: 'text', name: 'link'
                    end
                end
                tr do
                    td do
                        label 'Chọn ảnh cho banner desktop'
                    end
                    td do
                        input type: 'file', name: 'filedesktop', accept: 'image/jpg, image/jpeg, image/png'
                    end
                end
                tr do
                    td do
                        label 'Chọn ảnh cho banner mobile'
                    end
                    td do
                        input type: 'file', name: 'filemobile', accept: 'image/jpg, image/jpeg, image/png'
                    end
                end
            end
        end
    end
end
  