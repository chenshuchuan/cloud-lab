class TeamsController < ApplicationController
#  skip_authorization_check :only => [:new, :create, :destroy]
#  load_and_authorize_resource
  skip_authorization_check
  include TeamsHelper
  
  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.search(params)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @teams }
    end
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @team = Team.find(params[:id])
    get_user_by_team(@team.id)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @team }
    end
  end

  # GET /teams/new
  # GET /teams/new.json
  def new
    @team = Team.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @team }
    end
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
  end

  # POST /teams
  # POST /teams.json
  def create

    @team = Team.new(params[:team])
    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render json: @team, status: :created, location: @team }
      else
        format.html { render action: "new" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /teams/1
  # PUT /teams/1.json
  def update
    @team = Team.find(params[:id])

    respond_to do |format|
      if @team.update_attributes(params[:team])
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    respond_to do |format|
      format.html { redirect_to teams_url }
      format.json { head :no_content }
    end
  end

  def join
    if !join_team?
      @teamR = TeamRelationship.new(:user_id=>current_user.id, :team_id=>params[:id].to_i)
      @teamR.save
      redirect_to :action => 'show'
      flash[:success] = "Welcome you to join us!"
    else
      redirect_to :action => 'show'
      flash[:success] = "You have been join this team!"
    end
  end

  def leave
    if join_team?
      @teamR = TeamRelationship.where(:user_id=>current_user.id, :team_id=>params[:id].to_i)
      @teamR.destroy_all
      redirect_to :action => 'show_team'
      flash[:success] = "You have exited team successfully!"
    else
      redirect_to :action => 'show_team'
      flash[:success] = "Out of team failure!"
    end

  end

  def show_team
    show_my_team
  end

end
