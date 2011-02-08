require 'spec_helper'

describe "invitations/show.html.erb" do
  before(:each) do
    @invitation = assign(:invitation, stub_model(Invitation,
      :email => "Email",
      :invitee_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Email/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
