require 'rails_helper'

describe Enrollment, type: :model do

    before :all do
        institution = create(:institution)
        student = create(:student)
        @enrollment = create(:enrollment, institution_id: institution.id, student_id: student.id)
    end

    context 'db' do
        context 'columns' do
            it { should have_db_column(:course_name).of_type(:string) }
            it { should have_db_column(:course_price).of_type(:decimal) }
            it { should have_db_column(:number_payments).of_type(:integer) }
            it { should have_db_column(:due_day).of_type(:integer) }
            it { should have_db_column(:institution_id).of_type(:integer) }
            it { should have_db_column(:student_id).of_type(:integer) }
        end
    end

    context 'associations' do
        it { should have_many(:payment).dependent(:delete_all) }
        it { should belong_to(:institution) }
        it { should belong_to(:student) }
    end

    context 'validations' do
        it { should validate_presence_of(:course_name) }
        it { should validate_presence_of(:institution_id) }
        it { should validate_presence_of(:student_id) }
        it { should validate_presence_of(:course_price) }
        it { should validate_presence_of(:number_payments) }
        it { should validate_presence_of(:due_day) }
        it { should validate_inclusion_of(:number_payments).in_range(1..120).with_message('must be in 1..120') }
        it { should validate_inclusion_of(:due_day).in_range(1..31).with_message('must be in 1..31') }
        it do
            should validate_numericality_of(:course_price)
                .is_greater_than(0)
                .with_message('must be greater than 0')
        end
    end
end
