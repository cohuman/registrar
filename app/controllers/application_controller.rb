class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_user!
  
  def redirect_unless_admin
    unless current_user && current_user.admin?
      flash[:error] = 'You must be an admin'
      redirect_to('/fail')
    end
  end
  
  def redirect_unless_token
    unless current_user && current_user.access_token?
      redirect_to('/authorize')
    end
  end
  
  def access_token
    current_user.access_token
  end
end
