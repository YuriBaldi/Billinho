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

    describe 'PATCH /update' do
        it "updates a Payment and redirects to the Payment's page" do
            new_params = build(:payment)

            patch payment_url(@payment), params: { payment: {
              status: new_params.status
            } }

            @payment.reload
            should redirect_to(assigns(:payment))
            follow_redirect!
            should render_template(:show)
            expect(response.body).to include('Payment was successfully updated.')
            expect(response).to have_http_status(200)
        end

        it "updates a Payment with invalid params and redirects to the Payment's page" do
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
        it "deletes a Payment and redirects to the Payment's page" do
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
            get new_payment_url
            expect(response).to be_successful
        end

        it 'does not render a different template' do
            get '/payments/new'
            expect(response).to_not render_template(:show)
        end
    end

    describe 'POST /create' do
        it "creates a Payment and redirects to the Payment's page" do
            get '/payments/new'
            should render_template(:new)

            post '/payments', params: { payment: attributes_for(:payment).merge({
                enrollment_id: @enrollment.id
            }) }

            should redirect_to(assigns(:payment))
            follow_redirect!
            should render_template(:show)
            expect(response.body).to include('Payment was successfully created.')
            expect(response).to have_http_status(200)
        end

        it "creates a Payment with invalid params and redirects to the Payment's new page" do
            get '/payments/new'
            should render_template(:new)

            post '/payments', params: { payment: attributes_for(:payment, :invalid_params).merge({
                enrollment_id: nil,
                due_date: nil
            }) }

            should render_template(:new)
            expect(response.body).to include('Enrollment must exist')
            expect(response.body).to include('Enrollment can&#39;t be blank')
            expect(response.body).to include('Due date can&#39;t be blank')
            expect(response.body).to include('Value is not a number')
            expect(response.body).to include('Status must be open, delayed or paid')
            expect(response).to have_http_status(422)
        end
    end
end
