class ManagersController < ApplicationController
  before_filter :authenticate_login!
  load_and_authorize_resource
  # GET /managers
  # GET /managers.json
  def index
    #authorize! :index, @login, :message => 'Not authorized as an administrator.'
    #É preciso ir buscar a clinica do gestor atual para carregar a informação
    manager = Manager.first(:conditions => "login_id = #{current_login.id}")
    @clinic = manager.clinic

    @managers = Manager.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @managers }
    end
  end

  # GET /managers/1
  # GET /managers/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @manager }
    end
  end

  # GET /managers/new
  # GET /managers/new.json
  def new
    @manager = Manager.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @manager }
    end
  end

  # GET /managers/1/edit
  def edit
    
  end

  # POST /managers
  # POST /managers.json
  def create
    login_id = params[:manager].delete(:login_id)
    gender_id = params[:manager].delete(:gender_id)
    clinic_id = params[:manager].delete(:clinic_id)
    @manager = Manager.new(params[:manager])
  
    @manager.login_id = login_id
    @manager.gender_id = gender_id
    @manager.clinic_id = clinic_id

    respond_to do |format|
      if @manager.save
        format.html { redirect_to @manager, notice: 'Manager was successfully created.' }
        format.json { render json: @manager, status: :created, location: @manager }
      else
        format.html { render action: "new" }
        format.json { render json: @manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /managers/1
  # PUT /managers/1.json
  def update
    login_id = params[:manager].delete(:login_id)
    gender_id = params[:manager].delete(:gender_id)
    clinic_id = params[:manager].delete(:clinic_id)
    @manager = Manager.find(params[:id])

    @manager.login_id = login_id
    @manager.gender_id = gender_id
    @manager.clinic_id = clinic_id

    respond_to do |format|
      if @manager.update_attributes(params[:manager])
        format.html { redirect_to @manager, notice: 'Manager was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /managers/1
  # DELETE /managers/1.json
  def destroy
    @manager = Manager.find(params[:id])
    @manager.destroy

    respond_to do |format|
      format.html { redirect_to managers_url }
      format.json { head :no_content }
    end
  end
end
