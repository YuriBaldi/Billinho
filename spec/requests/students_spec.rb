require 'rails_helper'

describe 'Student Requests', type: :request do
    before(:each) do
        @institution = create(:institution)
        @student = create(:student)
    end

    describe 'GET /index' do
        it 'renders a successful response' do
            get students_url
            expect(response).to be_successful
        end
    end

    describe 'GET /show' do
        it 'renders a successful response' do
            get student_url(@student)
            expect(response).to be_successful
        end
    end

    describe 'GET /edit' do
        it 'render a successful response' do
            get edit_student_url(@student)
            expect(response).to be_successful
        end
    end

    describe 'PUT /update' do
        it 'updates a Student' do
            new_params = build(:student)

            put student_url(@student), params: { student: {
              name: new_params.name
            } }

            @student.reload
            should redirect_to(assigns(:student))
            follow_redirect!
            should render_template(:show)
            expect(@student.name).to eql(new_params.name)
            expect(response.body).to include('Student was successfully updated.')
            expect(response).to have_http_status(200)
        end

        it 'updates a Student with invalid params' do
            patch student_url(@student), params: {
              student: attributes_for(:student, :invalid_params)
            }

            should render_template(:edit)
            expect(response.body).to include('Cpf must be a number')
            expect(response.body).to include('Gender must be &#39;f&#39; (female) or &#39;m&#39; (male)')
            expect(response.body).to include('Payment type must be &#39;boleto&#39; or &#39;card&#39;')
            expect(response).to have_http_status(422)
        end
    end

    describe 'DELETE /destroy' do
        it 'deletes a student' do
            create(:enrollment, student_id: @student.id, institution_id: @institution.id)
            create(:enrollment, student_id: @student.id, institution_id: @institution.id)

            delete student_url(@student)

            expect(response).to redirect_to(students_url)
            follow_redirect!
            should render_template(:index)
            expect(response.body).to include('Student was successfully destroyed.')
            expect(response).to have_http_status(200)

            enrollments = Enrollment.where(student_id: @student.id).all
            payments = []
            enrollments.each do |enrollment|
                payments += Payment.where(enrollment_id: enrollment.id).all
            end
            expect(enrollments).to be_empty
            expect(payments).to be_empty
        end
    end

    describe 'GET /new' do
        it 'renders a successful response' do
            get new_student_url
            expect(response).to be_successful
            expect(response).to_not render_template(:show)
        end
    end

    describe 'POST /create' do
        it 'creates a student' do
            get '/students/new'
            should render_template(:new)

            post '/students', params: { student: attributes_for(:student) }

            should redirect_to(assigns(:student))
            follow_redirect!
            should render_template(:show)
            expect(response.body).to include('Student was successfully created.')
            expect(response).to have_http_status(200)
        end

        it 'creates a student with invalid params' do
            get '/students/new'
            should render_template(:new)

            post '/students', params: { student: attributes_for(:student, :invalid_params) }

            should render_template(:new)
            expect(response.body).to include('Cpf must be a number')
            expect(response).to have_http_status(422)
        end
    end
end
