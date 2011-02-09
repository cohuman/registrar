class AuthorizeController < ApplicationController
  def index
    begin
      request_token = CohumanToken.get_request_token("#{Site.domain}/authorize/callback")
      RequestToken.create(:user_id => current_user.id, :token => request_token.token, :secret => request_token.secret)
      redirect_to request_token.authorize_url
    rescue
      redirect_to '/fail'
    end
  end
  
  def callback
    begin 
      request_token = CohumanToken.request_token(request.referrer[/[a-z0-9]*$/i])
      access_token = request_token.get_access_token
      access_token = AccessToken.create(:user_id => current_user.id, :token => access_token.token, :secret => access_token.secret)
    rescue Exception => e
      flash e.message
    end
    redirect_to root_path
  end
end