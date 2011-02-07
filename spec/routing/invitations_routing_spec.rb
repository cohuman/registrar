require "spec_helper"

describe InvitationsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/invitations" }.should route_to(:controller => "invitations", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/invitations/new" }.should route_to(:controller => "invitations", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/invitations/1" }.should route_to(:controller => "invitations", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/invitations/1/edit" }.should route_to(:controller => "invitations", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/invitations" }.should route_to(:controller => "invitations", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/invitations/1" }.should route_to(:controller => "invitations", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/invitations/1" }.should route_to(:controller => "invitations", :action => "destroy", :id => "1")
    end

  end
end
