require 'spec_helper'

describe User do
  before do
    @user = User.create :email => 'foo@gmail.com', :password => 'good_password', :password_confirmation => 'good_password'
  end
  
  describe 'tokens' do
    it 'should have a cohuman_token' do
      # @user.cohuman_token.class.should == 
    end
  end
end
