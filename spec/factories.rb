FactoryBot.define do
    factory :institution do
        name { Faker::University.unique.name }
        cnpj { Faker::Number.unique.number(digits: 14) }
        institution_type { 'university' }

        trait :invalid_params do
            cnpj { Faker::Alphanumeric.alpha(number: 14) }
            institution_type { 'other' }
        end
    end

    factory :student do
        name { Faker::Name.unique.name }
        cpf { Faker::Number.unique.number(digits: 11) }
        birth_date { Faker::Date.backward }
        gender { 'f' }
        payment_type { 'card' }

        trait :invalid_params do
            cpf { Faker::Alphanumeric.alpha(number: 11) }
            gender { 'other' }
            payment_type { 'other' }
        end
    end

    factory :enrollment do
        course_price { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
        number_payments { Faker::Number.within(range: 1..4) }
        due_day { Faker::Number.between(from: 1, to: 31) }
        course_name { Faker::Educator.course_name }
        association :institution_id, factory: :institution
        association :student_id, factory: :student

        trait :invalid_params do
            course_price { Faker::Number.within(range: -100..-1) }
            number_payments { Faker::Number.within(range: -100..-1) }
            due_day { Faker::Number.between(from: 32, to: 100) }
        end

        trait :invalid_params_to_update do
            due_day { Faker::Number.between(from: 32, to: 100) }
        end
    end

    factory :payment do
        value { Faker::Number.decimal(l_digits: 2) }
        due_date { Faker::Date.forward }
        status { 'open' }
        association :enrollment_id, factory: :enrollment

        trait :invalid_params do
            value { Faker::Alphanumeric.alpha(number: 2) }
            status { 'other' }
        end
    end
end
