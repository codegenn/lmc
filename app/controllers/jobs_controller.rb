class JobsController < ApplicationController
  before_action :set_menu

  def index
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
