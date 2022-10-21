require "rails_helper"

describe "Institution Requests", :type => :request do
    describe "GET /index" do
        it "renders a successful response" do
            create(:institution)
            get institutions_url
            expect(response).to be_successful
        end
    end
    
    describe "GET /show" do
        it "renders a successful response" do
            institution = create(:institution)
            get institution_url(institution)
            expect(response).to be_successful
        end
    end

    describe "GET /new" do
        it "renders a successful response" do
            get new_institution_url
            expect(response).to be_successful
        end
    end

    describe "GET /edit" do
        it "render a successful response" do
            institution = create(:institution)
            get edit_institution_url(institution)
            expect(response).to be_successful
        end
    end

    describe "POST /create" do
        it "creates a Institution and redirects to the Institution's page" do
            get "/institutions/new"
            should render_template(:new)

            post "/institutions", params: { institution: attributes_for(:institution) }

            should redirect_to(assigns(:institution))
            follow_redirect!
            should render_template(:show)
            expect(response.body).to include("Institution was successfully created.")
            expect(response).to have_http_status(200)
        end

        it "does not render a different template" do
            get "/institutions/new"
            expect(response).to_not render_template(:show)
        end

        it "creates a Institution with invalid params and redirects to the Institution's new page" do
            get "/institutions/new"
            should render_template(:new)

            post "/institutions", params: { institution: attributes_for(:institution, :invalid_params) }

            should render_template(:new)
            expect(response.body).to include("Cnpj CNPJ must be a number")
            expect(response.body).to include("Institution type Institution type must be university, school or nursey")
            expect(response).to have_http_status(422)
        end
    end

    describe "PATCH /update" do
        it "updates a Institution and redirects to the Institution's page" do
            institution = create(:institution)
            new_params = build(:institution)
            patch institution_url(institution), params: { :institution => {
                :name => new_params.name, 
            }}
            institution.reload
            should redirect_to(assigns(:institution))
            follow_redirect!
            should render_template(:show)
            expect(response.body).to include("Institution was successfully updated.")
            expect(response).to have_http_status(200)
        end

        it "updates a Institution with invalid params and redirects to the Institution's page" do
            institution = create(:institution)
            new_params = build(:institution, :invalid_params)

            patch institution_url(institution), params: { 
                institution: attributes_for(:institution, :invalid_params) 
            }

            should render_template(:edit)
            expect(response.body).to include("Cnpj CNPJ must be a number")
            expect(response.body).to include("Institution type Institution type must be university, school or nursey")
            expect(response).to have_http_status(422)
        end
    end

    describe "DELETE /destroy" do
        it "deletes a Institution and redirects to the Institution's page" do
            institution = create(:institution)
            delete institution_url(institution)
            expect(response).to redirect_to(institutions_url)
            follow_redirect!
            should render_template(:index)
            expect(response.body).to include("Institution was successfully destroyed.")
            expect(response).to have_http_status(200)
        end
    end
end
