class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: %i[show edit update destroy]

  # GET /enrollments or /enrollments.json
  def index
    @enrollments = Enrollment.all
  end

  # GET /enrollments/1 or /enrollments/1.json
  def show; end

  # GET /enrollments/new
  def new
    @enrollment = Enrollment.new
  end

  # GET /enrollments/1/edit
  def edit; end

  # POST /enrollments or /enrollments.json
  def create
    @enrollment = Enrollment.new(enrollment_params)

    respond_to do |format|
      if @enrollment.save
        format.html { redirect_to enrollment_url(@enrollment), notice: 'Enrollment was successfully created.' }
        format.json { render :show, status: :created, location: @enrollment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enrollments/1 or /enrollments/1.json
  def update
    respond_to do |format|
      if params.permitted?
        if @enrollment.update!(enrollments_params_can_updated)
          format.html { redirect_to enrollment_url(@enrollment), notice: 'Enrollment was successfully updated.' }
          format.json { render :show, status: :ok, location: @enrollment }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @enrollment.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to enrollment_url(@enrollment), notice: 'Updating Course Price or Number of Payments is not allowed.' }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    @enrollment.destroy

    respond_to do |format|
      format.html { redirect_to enrollments_url, notice: 'Enrollment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_enrollment
    @enrollment = Enrollment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def enrollment_params
    params.require(:enrollment)
          .permit(:student_id, :institution_id, :course_price, :number_payments, :due_day, :course_name)
  end

  def enrollments_params_can_updated
    params.require(:enrollment).permit(:student_id, :institution_id, :due_day, :course_name)
  end

  def prof
    @student = Student.find(enrollment_params[:student_id])
    @institution = Institution.find(enrollment_params[:institution_id])
  end
end
