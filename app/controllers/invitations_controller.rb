class InvitationsController < ApplicationController
  # GET /invitations
  # GET /invitations.xml
  before_filter :redirect_unless_token
  
  def index
    @invitations = Invitation.all(:conditions => {:inviter_id => current_user.id})

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invitations }
    end
  end

  # GET /invitations/1
  # GET /invitations/1.xml
  def show
    @invitation = Invitation.find(params[:id])
    if @invitation.inviter_id != current_user.id
      redirect_to root_path 
    else
      @tasks = @invitation.get_tasks
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @invitation }
      end
    end
  end

  # GET /invitations/new
  # GET /invitations/new.xml
  def new
    @invitation = Invitation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invitation }
    end
  end

  # POST /invitations
  # POST /invitations.xml
  def create
    @invitation = Invitation.new(params[:invitation].merge(:inviter_id => current_user.id))

    begin
      @invitation.save
      redirect_to( @invitation, :notice => 'Invitation was successfully created.' )
    rescue Exception => e
      flash[:error] = e.message
      render :action => "new"
    end
  end
end
