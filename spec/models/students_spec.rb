require 'rails_helper'

describe Student, type: :model do
    before :all do
        @student = create (:student)
    end

    context 'db' do
        context 'columns' do
            it { should have_db_column(:name).of_type(:string).with_options(null: false) }
            it { should have_db_column(:cpf).of_type(:string).with_options(null: false) }
            it { should have_db_column(:birth_date).of_type(:string).with_options(null: false) }
            it { should have_db_column(:phone).of_type(:string).with_options(null: false) }
            it { should have_db_column(:gender).of_type(:string).with_options(null: false) }
            it { should have_db_column(:payment_type).of_type(:string).with_options(null: false) }
        end
    end

    context 'associations' do
        it { should has_many(:enrollments).dependent(:destroy) }      
    end

    context 'validations' do
        it { should validate_presence_of(:name) }
        #it { should validate_uniqueness_of(:name).with_message('is already in use') }
        it { should validate_uniqueness_of(:cpf).case_insensitive.with_message('is already in use') }
        it { should validate_numericality_of(:cpf).only_integer.with_message('must be a number') }
        it { should validate_presence_of(:birth_date) }
        it { should validate_numericality_of(:birth_date).only_integer.with_message('must be a number') }
        it { should validate_numericality_of(:phone).only_integer.with_message('must be a number') }
        it { should validate_uniqueness_of(:phone).case_insensitive.with_message('is already in use') }
        it do
            should validate_inclusion_of(:gender)
            .in_array(['m', 'f'])
            .with_message("must be 'f' (female) or 'm' (male)") 
        end
        
        it do
            should validate_inclusion_of(:payment_type)
            .in_array("%w[boleto card]")
            .with_message("must be 'boleto' or 'card'")
        end
    end
end 


        

