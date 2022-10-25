require 'rails_helper'

describe Payment, type: :model do
    before :all do
        institution = create(:institution)
        student = create(:student)
        enrollment = create(:enrollment, institution_id: institution.id, student_id: student.id)
        @payment = create(:payment, enrollment_id: enrollment.id)
    end

    context 'db' do
        context 'columns' do
            it { should have_db_column(:value).of_type(:decimal) }
            it { should have_db_column(:due_date).of_type(:date) }
            it { should have_db_column(:status).of_type(:string).with_options(default: 'open') }
            it { should have_db_column(:enrollment_id).of_type(:integer).with_options(null: false) }
        end
    end

    context 'associations' do
        it { should belong_to(:enrollment) }
    end

    context 'validations' do
        it { should validate_presence_of(:value) }
        it { should validate_presence_of(:due_date) }
        it { should validate_presence_of(:enrollment_id) }
        it { should validate_presence_of(:status) }
        it do
            should validate_inclusion_of(:status)
              .in_array(%w[open delayed paid])
              .with_message('must be open, delayed or paid')
        end
    end
end
