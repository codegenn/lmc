ActiveAdmin.register MasterDatum do
  controller do 
    def show 
      MasterDatum.all
    end
  
    def create 
      @master_datum = MasterDatum.new(params_data)
  
      if @master_datum.save 
        redirect_to admin_master_data_path, notice: "User updated successfully."
      else
        redirect_to admin_master_data_path, notice: @master_datum.errors.full_messages.to_sentence
      end
    end
  
    def update 
      @master_datum = MasterDatum.find_by(id: params[:id])
      if @master_datum.present?
        @master_datum.update(params_data)
      end
      
      redirect_to admin_master_data_path, notice: "User updated successfully."
    end
  
    def destroy 
      @master_datum = MasterDatum.find_by(id: params[:id])
      if @master_datum.present?
        @master_datum.destroy!
      end
  
      redirect_to admin_master_data_path, notice: "User delete successfully."
    end
  
    private 
    def params_data
      {
        :type_name => params[:master_datum][:type_name],
        :key => params[:master_datum][:key],
        :value => params[:master_datum][:value],
        :status => params[:master_datum][:status]
      }
    end
  end
end
