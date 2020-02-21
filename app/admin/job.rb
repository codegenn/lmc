ActiveAdmin.register Job do
  permit_params :title, :short_description, :content
end
