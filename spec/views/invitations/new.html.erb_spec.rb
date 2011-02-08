require 'spec_helper'

describe "invitations/new.html.erb" do
  before(:each) do
    assign(:invitation, stub_model(Invitation,
      :email => "MyString",
      :invitee_id => 1
    ).as_new_record)
  end

  it "renders new invitation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => invitations_path, :method => "post" do
      assert_select "input#invitation_email", :name => "invitation[email]"
      assert_select "input#invitation_invitee_id", :name => "invitation[invitee_id]"
    end
  end
end
