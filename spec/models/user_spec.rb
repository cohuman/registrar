require 'spec_helper'

describe User do
  before do
    @user = User.create :email => 'foo@gmail.com', :password => 'good_password', :password_confirmation => 'good_password'
  end
  
  describe 'tokens' do
    it 'should have tokens' do
      token = AccessToken.create(:user => @user, :token => 'FOO', :secret => "BAR")
      @user.tokens.size.should == 1
      @user.tokens.first.should == token 
    end
    
    it 'should have invitations' do
      invitation = Invitation.create(:inviter_id => @user.id, :invitee_id => '42')
      @user.invitations.size.should == 1
      @user.invitations.first.should == invitation
    end
  end
end
