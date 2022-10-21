FactoryBot.define do
    factory :institution do
        name {Faker::University.unique.name}
        cnpj {Faker::Number.unique.number(digits: 14)}
        institution_type {'university'}
    end
end