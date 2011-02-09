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
      invitation = Invitation.new(:inviter_id => @user.id, :invitee_id => '42')
      invitation.stub!(:post_invite).and_return(true)
      invitation.save
      @user.invitations.size.should == 1
      @user.invitations.first.should == invitation
    end
  end
end
