class CohumanToken < ConsumerToken
  def self.key
    credentials[:key]
  end
  
  def self.secret
    credentials[:secret]
  end
  
  def self.options
    credentials[:options]
  end
  
  def self.request_token(code)
    found_token = RequestToken.first(:conditions => {:token => code})
    OAuth::RequestToken.new(consumer, found_token.token, found_token.secret)
  end
end