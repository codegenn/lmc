class JobsController < ApplicationController
  include ApplicationHelper
  before_action :set_menu

  def index
    breadcrumb I18n.t("page.menu.join_us"), jobs_path
    @jobs = Job.all
  end

  def show
    @job = Job.find_by_id(params[:id])
    @application = Application.new
  end

  def set_menu
    @menu = 'joinus'
  end
end
