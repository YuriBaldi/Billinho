require 'rails_helper'

describe 'Enrollment Requests', type: :request do
    before(:all) do
        @institution = create(:institution)
        @student = create(:student)
    end

    before(:each) do
        @enrollment = create(:enrollment, institution_id: @institution.id, student_id: @student.id)
    end

    describe 'GET /index' do
        it 'renders a successful response' do
            get enrollments_url
            expect(response).to be_successful
        end
    end

    describe 'GET /show' do
        it 'renders a successful response' do
            get enrollment_url(@enrollment)
            expect(response).to be_successful
        end
    end

    describe 'GET /edit' do
        it 'render a successful response' do
            get edit_enrollment_url(@enrollment)
            expect(response).to be_successful
        end
    end

    describe 'PATCH /update' do
        it "updates a Enrollment" do
            new_params = build(:enrollment)

            patch enrollment_url(@enrollment), params: { enrollment: {
              course_name: new_params.course_name
            } }

            @enrollment.reload
            should redirect_to(assigns(:enrollment))
            follow_redirect!
            should render_template(:show)
            expect(response.body).to include('Enrollment was successfully updated.')
            expect(response).to have_http_status(200)
        end

        it "updates a Enrollment with invalid params" do
            patch enrollment_url(@enrollment), params: {
              enrollment: attributes_for(:enrollment, :invalid_params)
            }

            should render_template(:edit)
            expect(response.body).to include('Number payments must be in 1..120')
            expect(response.body).to include('Due day must be in 1..31')
            expect(response.body).to include('Course price must be greater than 0')
            expect(response).to have_http_status(422)
        end
    end

    describe 'DELETE /destroy' do
        it "deletes a Enrollment" do
            delete enrollment_url(@enrollment)
            expect(response).to redirect_to(enrollments_url)
            follow_redirect!
            should render_template(:index)
            expect(response.body).to include('Enrollment was successfully destroyed.')
            expect(response).to have_http_status(200)

            payments = Payment.where(enrollment_id: @enrollment.id).all
            expect(payments).to be_empty
        end
    end

    describe 'GET /new' do
        it 'renders a successful response' do
            get new_enrollment_url
            expect(response).to be_successful
        end

        it 'does not render a different template' do
            get '/enrollments/new'
            expect(response).to_not render_template(:show)
        end
    end

    describe 'POST /create' do
        it 'creates a Enrollment with valid params' do
            get '/enrollments/new'
            should render_template(:new)

            post '/enrollments', params: { enrollment: attributes_for(:enrollment).merge({
                institution_id: @institution.id,
                student_id: @student.id
            }) }

            should redirect_to(assigns(:enrollment))
            follow_redirect!
            should render_template(:show)
            expect(response.body).to include('Enrollment was successfully created.')
            expect(response).to have_http_status(200)
        end

        it 'creates a Enrollment with valid params and checks the payments created' do
            params = attributes_for(:enrollment)

            expect do
                post '/enrollments', params: { enrollment: params
                  .merge({ institution_id: @institution.id, student_id: @student.id }) }
            end.to change { Payment.count }.by(params[:number_payments])

            enroll = Enrollment.last
            payments = Payment.where(enrollment_id: enroll.id).all

            expected_value = enroll.course_price / enroll.number_payments
            expected_status = 'open'
            current_date = Date.today
            expected_due_date = Date.new(current_date.year, current_date.mon, enroll.due_day)

            expected_due_date = expected_due_date.next_month if enroll.due_day <= current_date.mday

            payments.each do |payment|
                expect(payment.value).to be_within(0.001).of(expected_value)
                expect(payment.status).to eql(expected_status)
                expect(payment.due_date).to eql(expected_due_date)
                expected_due_date = expected_due_date.next_month
            end
        end

        it 'creates a Enrollment with invalid params' do
            get '/enrollments/new'
            should render_template(:new)

            post '/enrollments', params: { enrollment: attributes_for(:enrollment, :invalid_params).merge({
                institution_id: nil,
                student_id: nil,
                course_name: nil
            }) }

            should render_template(:new)
            expect(response.body).to include('Institution must exist')
            expect(response.body).to include('Student must exist')
            expect(response.body).to include('Institution can&#39;t be blank')
            expect(response.body).to include('Student can&#39;t be blank')
            expect(response.body).to include('Course name can&#39;t be blank')
            expect(response.body).to include('Number payments must be in 1..120')
            expect(response.body).to include('Due day must be in 1..31')
            expect(response.body).to include('Course price must be greater than 0')
            expect(response).to have_http_status(422)
        end
    end
end
