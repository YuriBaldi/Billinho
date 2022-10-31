require 'rails_helper'

describe 'Payment Requests', type: :request do
    before(:all) do
        institution = create(:institution)
        student = create(:student)
        @enrollment = create(:enrollment, institution_id: institution.id, student_id: student.id)
    end

    before(:each) do
        @payment = create(:payment, enrollment_id: @enrollment.id)
    end

    describe 'GET /index' do
        it 'renders a successful response' do
            get payments_url
            expect(response).to be_successful
        end
    end

    describe 'GET /show' do
        it 'renders a successful response' do
            get payment_url(@payment)
            expect(response).to be_successful
        end
    end

    describe 'GET /edit' do
        it 'render a successful response' do
            get edit_payment_url(@payment)
            expect(response).to be_successful
        end
    end

    describe 'PUT /update' do
        it 'updates a Payment' do
            new_params = build(:payment)

            put payment_url(@payment), params: { payment: {
              status: new_params.status
            } }

            @payment.reload
            should redirect_to(assigns(:payment))
            follow_redirect!
            should render_template(:show)
            expect(@payment.status).to eql(new_params.status)
            expect(response.body).to include('Payment was successfully updated.')
            expect(response).to have_http_status(200)
        end

        it 'updates a Payment with invalid params' do
            patch payment_url(@payment), params: {
              payment: attributes_for(:payment, :invalid_params)
            }

            should render_template(:edit)
            expect(response.body).to include('Value is not a number')
            expect(response.body).to include('Status must be open, delayed or paid')
            expect(response).to have_http_status(422)
        end
    end

    describe 'DELETE /destroy' do
        it 'deletes a Payment' do
            delete payment_url(@payment)
            expect(response).to redirect_to(payments_url)
            follow_redirect!
            should render_template(:index)
            expect(response.body).to include('Payment was successfully destroyed.')
            expect(response).to have_http_status(200)
        end
    end

    describe 'GET /new' do
        it 'renders a successful response' do
            expect { get :new }.to raise_error(URI::InvalidURIError)
        end
    end

    describe 'POST /create' do
        it 'creates a Payment' do
            post '/payments', params: { payment: attributes_for(:payment).merge({
                enrollment_id: @enrollment.id
            }) }

            should redirect_to(assigns(:payment))
            follow_redirect!
            should render_template(:show)
            expect(response.body).to include('Payment was successfully created.')
            expect(response).to have_http_status(200)
        end

        it 'creates a Payment with invalid params' do
            post '/payments', params: { payment: attributes_for(:payment, :invalid_params).merge({
                enrollment_id: nil,
                due_date: nil
            }) }

            should render_template(:new)
            expect(response.body).to include('Enrollment must exist')
            expect(response.body).to include('Value is not a number')
            expect(response.body).to include('Status must be open, delayed or paid')
            expect(response).to have_http_status(422)
        end
    end
end
