require 'rails_helper'

describe Institution, type: :model do

    context 'db' do
        context 'columns' do
            it { should have_db_column(:name).of_type(:string).with_options(:null => false) }
            it { should have_db_column(:cnpj).of_type(:string).with_options(:null => false) }
            it { should have_db_column(:institution_type).of_type(:string).with_options(:null => false) }
        end
    end

    before :all do
        @institution = create(:institution)
    end

    context 'associations' do
        it { should have_many(:enrollments).dependent(:destroy) }
    end

    context 'validations' do
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