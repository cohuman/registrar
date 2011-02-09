class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_many :tokens, :class_name => 'ConsumerToken', :dependent => :destroy
  has_many :access_tokens, :class_name => 'AccessToken'
  has_many :request_tokens, :class_name => 'RequestToken'
  
  has_many :invitations, :foreign_key => :inviter_id
  
  
  def access_token?
    !!access_tokens.first
  end
  
  def access_token
    if !@access_token && access_token?
      token = access_tokens.first
      @access_token = OAuth::AccessToken.new(CohumanToken.consumer, token.token, token.secret)
    end
    @access_token
  end
end
