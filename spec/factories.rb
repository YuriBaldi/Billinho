require 'rails_helper'

FactoryBot.define do
    factory :institution do
        name {'Institution Name'}
        cnpj {'01657521000189'}
        institution_type {'university'}
    end
end