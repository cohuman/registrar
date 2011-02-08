require 'oauth/models/consumers/token'
class ConsumerToken < ActiveRecord::Base
  include Oauth::Models::Consumers::Token
  
  # Modify this with class_name etc to match your application
  belongs_to :user
  
end