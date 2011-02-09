require 'spec_helper'

describe Invitation do
  before do
    @token = mock('AccessToken')
    @user = User.create :email => 'foo@gmail.com', :password => 'good_password', :password_confirmation => 'good_password'
    @mock_response = mock('response')
  end
  
  it 'should have an inviter' do
    invitation = Invitation.new(:inviter_id => @user.id, :invitee_id => 42, :email => 'someone@somewhere.com')
    invitation.stub!(:post_invite)
    invitation.save
    invitation.inviter.should == @user
  end
  
  describe '#post_invite' do
    before do
      @invitation = Invitation.new(:inviter => @user, :email => 'someone@somewhere.com')
      @response = File.read( "#{Rails.root}/spec/data/post_invitation.js")
      @existing_response = File.read( "#{Rails.root}/spec/data/post_invitation_existing.js")
      @error_response = File.read("#{Rails.root}/spec/data/error.js")
    end
    
    describe 'basic stuff' do
      before do
        @invitation.stub!(:post_tasks)
      end
      
      it 'gets called before create' do
        @invitation.should_receive(:post_invite)
        @invitation.save
      end
    
      it 'makes a request to Cohuman /invitation with the email' do
        @mock_response.should_receive(:body).any_number_of_times.and_return(@response)
        @token.should_receive(:post).with('http://api.cohuman.com/invitation', hash_including(:addresses => 'someone@somewhere.com')).and_return(@mock_response)
        @user.should_receive(:access_token).and_return(@token)
      
        @invitation.post_invite
      end
    
      it 'parses the invitee id out of the response' do
        @mock_response.should_receive(:body).any_number_of_times.and_return(@response)
        @token.should_receive(:post).and_return(@mock_response)
        @user.should_receive(:access_token).and_return(@token)
      
        @invitation.post_invite
        @invitation.invitee_id.should == 17347
      end
    
      it 'parses the invitee id out of existing users' do
        @mock_response.should_receive(:body).any_number_of_times.and_return(@existing_response)
        @token.should_receive(:post).and_return(@mock_response)
        @user.should_receive(:access_token).and_return(@token)
      
        @invitation.post_invite
        @invitation.invitee_id.should == 32
      end
    
      it 'raises an error if it cannot find a user' do
        @mock_response.should_receive(:body).any_number_of_times.and_return(@error_response)
        @token.should_receive(:post).and_return(@mock_response)
        @user.should_receive(:access_token).and_return(@token)
      
        lambda{ @invitation.post_invite }.should raise_error('Something went wrong')
      end
    end
    
    it 'calls #post_tasks' do
      @mock_response.should_receive(:body).any_number_of_times.and_return(@existing_response)
      @token.stub!(:post).and_return(@mock_response)
      @user.stub!(:access_token).and_return(@token)
      @invitation.should_receive(:post_tasks)
    
      @invitation.post_invite
    end
    
    describe '#post_tasks' do
      before do
        @invitation.invitee_id = 42
        @invitation.stub!(:post_invite)
        @task_response = ''
      end
      
      it 'makes a post request to Cohuman with multiple tasks' do
        @mock_response.should_receive(:body).any_number_of_times.and_return(@task_response)
        @invitation.stub!(:generate_names).and_return('task one; task two; task three')
        @token.should_receive(:post).with(
          'http://api.cohuman.com/task', 
          hash_including(:name => 'task one; task two; task three', :owner_id => 42)
        ).and_return(@mock_response)
        @user.should_receive(:access_token).and_return(@token)
        
        @invitation.post_tasks
      end
    end
  end
  
  describe '#generate_names' do
    before do
      @invitation = Invitation.new
    end
    
    it 'has the right number of tasks in the constant' do
      Invitation::TASK_NAMES.size.should == 59
    end
    
    it 'semicolon deliminates the tasks' do
      @invitation.generate_names.split('; ').size.should == 3
    end
    
    it 'picks three random tasks' do
      names = @invitation.generate_names.split('; ')
      Invitation::TASK_NAMES.should include(*names)
    end
  end
  
  describe '#get_tasks' do
    before do
      @invitation = Invitation.new(:inviter_id => @user.id, :invitee_id => 42, :email => 'someone@somewhere.com')
      @invitation.stub!(:inviter).and_return(@user)
      @user.stub!(:access_token).and_return(@token)
      @user_info = File.read( "#{Rails.root}/spec/data/user_info.js")
      @error = File.read( "#{Rails.root}/spec/data/error.js")
    end
    
    it 'makes a get request to Cohuman for user information' do
      @mock_response.should_receive(:body).any_number_of_times.and_return(@user_info)
      @token.should_receive(:get).with("http://api.cohuman.com/user/42", anything).and_return(@mock_response)
      
      @invitation.get_tasks
    end
    
    it 'returns an array of task names' do
      @mock_response.should_receive(:body).any_number_of_times.and_return(@user_info)
      @token.stub!(:get).and_return(@mock_response)
      @invitation.get_tasks.should == ['new task 1', 'new task 2']
    end
    
    it 'returns an empty array if an error message is returned' do
      @mock_response.should_receive(:body).any_number_of_times.and_return(@error)
      @token.stub!(:get).and_return(@mock_response)
      @invitation.get_tasks.should == []
    end
  end
end
