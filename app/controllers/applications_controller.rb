class ApplicationsController < ApplicationController
  def create
    @application = Application.new(application_params)

    if @application.save
      flash[:success] = 'Thank you for your application. We will check and contact to you soon'
      redirect_to jobs_path
    else
      flash[:danger] = @application.errors.full_messages.to_sentence
      @job = Job.find_by_id(application_params[:job_id])
      render 'jobs/show'
    end
  end

  private
  def application_params
    params.require(:application).permit(:name, :email, :phone_number, :cv, :job_id)
  end
end
