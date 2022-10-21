FactoryBot.define do
    factory :institution do
        name {Faker::University.unique.name}
        cnpj {Faker::Number.unique.number(digits: 14)}
        institution_type {'university'}

        trait :invalid_params do
            cnpj {Faker::Alphanumeric.alpha(number: 14)}
            institution_type {'other'}
        end
    end
end