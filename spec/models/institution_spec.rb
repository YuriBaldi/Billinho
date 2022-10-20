require 'rails_helper'

describe Institution, type: :model do
    describe 'associations' do
        subject { build(:institution) }
        it { should have_many(:enrollments).dependent(:destroy) }
    end

    describe 'validations' do
        subject { build(:institution) }
        it { should validate_presence_of(:name) }

        it do
            should validate_uniqueness_of(:name).with_message('Name is already in use')
        end

        it do
            should validate_uniqueness_of(:cnpj).case_insensitive.with_message('CNPJ is already in use')
        end

        it do
            should validate_numericality_of(:cnpj).only_integer.with_message('CNPJ must be a number')
        end

        it do
            should validate_inclusion_of(:institution_type).
                in_array(%w(university school nursey)).
                with_message('Institution type must be university, school or nursey')
        end
    end
end