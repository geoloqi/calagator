class PeopleController < ApplicationController
  include SquashManyDuplicatesMixin # Provides squash_many_duplicates

  # GET /people
  # GET /people.xml
  def index
    # @people = Person.non_duplicates.ordered_by_ui_field(params[:order])
    @people = Person.all

    @page_title = "People"

    respond_to do |format|
      format.html # *.html.erb
      format.kml  # *.kml.erb
      format.json { render :json => @people.to_json(:include => :venue), :callback => params[:callback] }
    end
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    @person = Person.new
    @page_title = "Add a Person"

    respond_to do |format|
      format.html { render :layout => !(params[:layout]=="false") }
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
    @page_title = "Editing '#{@person.name}'"
  end

  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(params[:person])

    if evil_robot = !params[:trap_field].blank?
      flash[:failure] = "<h3>Evil Robot</h3> We didn't create this person because we think you're an evil robot. If you're really not an evil robot, look at the form instructions more carefully. If this doesn't work please file a bug report and let us know."
    end

    respond_to do |format|
      if !evil_robot && @person.save
        flash[:success] = 'Person was successfully created.'
        format.html { redirect_to( person_path(@person) ) }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /people/1
  # GET /people/1.xml
  def show
    begin
      @person = Person.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      flash[:failure] = e.to_s
      return redirect_to(people_path)
    end

    return redirect_to(person_url(@person.duplicate_of)) if @person.duplicate?

    @page_title = @person.name

    respond_to do |format|
      format.html { # show.html.erb
        # @future_events = @venue.events.order("start_time ASC").future.non_duplicates.includes(:venue)
        # @past_events = @venue.events.order("start_time DESC").past.non_duplicates.includes(:venue)
        @future_events = []
        @past_events = []
      }
      format.xml  { render :xml => @venue }
      format.json  { render :json => @venue, :callback => params[:callback] }
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    @person = Person.find(params[:id])
    
    if evil_robot = !params[:trap_field].blank?
      flash[:failure] = "<h3>Evil Robot</h3> We didn't update this person because we think you're an evil robot. If you're really not an evil robot, look at the form instructions more carefully. If this doesn't work please file a bug report and let us know."
    end

    respond_to do |format|
      if !evil_robot && @person.update_attributes(params[:person])
        flash[:success] = 'Person was successfully updated.'
        format.html { 
          if(!params[:from_event].blank?)
            redirect_to(event_url(params[:from_event]))
          else
            redirect_to( person_path(@person) )
          end
          }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end


end
