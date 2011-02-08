require 'spec_helper'

describe CohumanToken do
  describe 'credentials' do
    it 'has the right key' do
      CohumanToken.key.should == 'TEST_KEY'
    end
    
    it 'has the right secret' do
      CohumanToken.secret.should == 'TEST_SECRET'
    end
    
    it 'has the right options' do
      CohumanToken.options.should == {
        'site' => 'http://cohuman.com',
        'request_token_path' => '/api/token/request',
        'authorize_path' => '/api/authorize',
        'access_token_path' => '/api/token/access'
      }
    end
  end
  
  
end