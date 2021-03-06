class PatientsController < ApplicationController
  before_filter :authenticate_login!
  load_and_authorize_resource
  # GET /patients
  # GET /patients.json
  def index
    
    #Fazer a verificação se é neuropsicologo
    if current_login.has_role? :secretary
      logged_user = Secretary.first(:conditions => "login_id = #{current_login.id}")
    elsif current_login.has_role? :neuropsychologist
      logged_user = Neuropsychologist.first(:conditions => "login_id = #{current_login.id}")
    end

    @patients = Patient.is_active.in_clinic(logged_user.clinic.id).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @patients }
    end
  end

  # GET /patients/1
  # GET /patients/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @patient }
    end
  end

  # GET /patients/new
  # GET /patients/new.json
  def new
    @pageType = "new"
    @patient = Patient.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @patient }
    end
  end

  # GET /patients/1/edit
  def edit
    @pageType = "edit"
    @patient.email = @patient.login.email

  end

  # POST /patients
  # POST /patients.json
  def create
    login = Login.new
    login.email = params[:patient][:email]
    login.password = "passwordGerada" 

    login.add_role :patient

    gender_id = params[:patient].delete(:gender_id)
    clinic_id = params[:patient].delete(:clinic_id)
    civil_status_id = params[:patient].delete(:civil_status_id)
    handedness_id = params[:patient].delete(:handedness_id)
    @patient = Patient.new(params[:patient])

    @patient.gender_id = gender_id
    secretary = Secretary.first(:conditions => "login_id = #{current_login.id}")
    @patient.clinic_id = secretary.clinic.id
    @patient.civil_status_id = civil_status_id
    @patient.handedness_id = handedness_id


    flag = true
    begin
      Patient.transaction do
        Login.transaction do
          login.save!
          @patient.login_id = login.id
          @patient.save!
        end
      end
      rescue ActiveRecord::RecordInvalid => invalid
        respond_to do |format| 
          format.html { render action: "new" }
          flag = false
        end
    end
    if flag == true
      respond_to do |format|
        format.html { redirect_to @patient, notice: 'Patient was successfully created.' }
      end
    end

  end

  # PUT /patients/1
  # PUT /patients/1.json
  def update
    
    
    gender_id = params[:patient].delete(:gender_id)
    #clinic_id = params[:patient].delete(:clinic_id)
    civil_status_id = params[:patient].delete(:civil_status_id)
    handedness_id = params[:patient].delete(:handedness_id)
    login = @patient.login
    
    
    
    @patient.gender_id = gender_id
    #@patient.clinic_id = clinic_id
    @patient.civil_status_id = civil_status_id
    @patient.handedness_id = handedness_id

    if(params[:patient][:palavrapass].blank?)
      pass = login.password
    else 
      pass = params[:patient][:palavrapass]
    end


    begin
      Patient.transaction do
        Login.transaction do
          @patient.update_attributes(params[:patient])
          login.update_attributes(:email => params[:patient][:email], :password => pass)

        end
      end
      rescue ActiveRecord::RecordInvalid => invalid
        respond_to do |format| 
          format.html { render action: "new" }
        end
    end
      respond_to do |format|
        format.html { redirect_to @patient, notice: 'Patient was successfully created.' }
      end



  end

  # DELETE /patients/1
  # DELETE /patients/1.json
  def destroy
    @patient = Patient.find(params[:id])
    @patient.destroy

    respond_to do |format|
      format.html { redirect_to patients_url }
      format.json { head :no_content }
    end
  end
end
