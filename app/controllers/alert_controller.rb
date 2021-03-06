class AlertController < ApplicationController
  
  def create
    advanced_settings = params.require(:alert).permit(:phone,:email,:people,:start,:end)
    
    # defaults to 2 hours monitored if one is missing
    if params[:alert][:start] == "" && params[:alert][:end] == ""
      advanced_settings[:allday] = true
    elsif params[:alert][:start] == "" && params[:alert][:end] != nil
      advanced_settings[:start] = Time.parse(params[:alert][:end]) - 2.hours
    elsif params[:alert][:start] != nil && params[:alert][:end] == ""
      advanced_settings[:end] = Time.parse(params[:alert][:start]) + 2.hours
    else
      advanced_settings[:allday] = false
    end
    if Alert.find_by(user_id: current_user.id).nil?
      advanced_settings[:user_id] = current_user.id
      Alert.create(advanced_settings)
    else
      alert = Alert.find_by(user_id: current_user.id)
      alert.update_attributes(advanced_settings)
    end
    redirect_to dashboard_path
  end

end
