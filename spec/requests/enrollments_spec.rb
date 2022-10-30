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

    describe 'PUT /update' do
        it 'updates a Enrollment' do
            old_number_payments = @enrollment.number_payments
            old_payment = Payment.where(enrollment_id: @enrollment.id).all
            new_params = build(:enrollment)

            put enrollment_url(@enrollment), params: { enrollment: {
              due_day: new_params.due_day,
              number_payments: new_params.number_payments
            } }

            @enrollment.reload
            should redirect_to(assigns(:enrollment))
            follow_redirect!
            should render_template(:show)
            expect(@enrollment.due_day).to eql(new_params.due_day)
            expect(@enrollment.number_payments).to eql(old_number_payments)
            expect(response.body).to include('Enrollment was successfully updated.')
            expect(response).to have_http_status(200)

            payments = Payment.where(enrollment_id: @enrollment.id, status: 'open').all
            old_payment.zip(payments).each do |old, actual|
                expect(actual.due_date).to eql(@enrollment.get_due_date(old.due_date, @enrollment.due_day))
            end
        end

        it 'updates a Enrollment with invalid params' do
            put enrollment_url(@enrollment), params: {
              enrollment: attributes_for(:enrollment, :invalid_params_to_update)
            }

            should render_template(:edit)
            expect(response.body).to include('Due day must be in 1..31')
            expect(response).to have_http_status(422)
        end
    end

    describe 'DELETE /destroy' do
        it 'deletes a Enrollment' do
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
            expected_due_date = enroll.get_due_date(Date.today, enroll.due_day)

            payments.each do |payment|
                expect(payment.value).to be_within(0.001).of(expected_value)
                expect(payment.status).to eql('open')
                expect(payment.due_date).to eql(expected_due_date)
                expected_due_date = enroll.get_due_date(expected_due_date.next_month, enroll.due_day)
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
            expect(response.body).to include('Due day must be in 1..31')
            expect(response.body).to include('Course price must be greater than 0')
            expect(response).to have_http_status(422)
        end
    end
end
