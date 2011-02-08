require 'spec_helper'

describe "invitations/index.html.erb" do
  before(:each) do
    assign(:invitations, [
      stub_model(Invitation,
        :email => "Email",
        :invitee_id => 1
      ),
      stub_model(Invitation,
        :email => "Email",
        :invitee_id => 1
      )
    ])
  end

  it "renders a list of invitations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
