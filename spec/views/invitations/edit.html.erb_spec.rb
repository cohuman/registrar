require 'spec_helper'

describe "invitations/edit.html.erb" do
  before(:each) do
    @invitation = assign(:invitation, stub_model(Invitation,
      :email => "MyString",
      :user_id => 1
    ))
  end

  it "renders the edit invitation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => invitations_path(@invitation), :method => "post" do
      assert_select "input#invitation_email", :name => "invitation[email]"
      assert_select "input#invitation_user_id", :name => "invitation[user_id]"
    end
  end
end
