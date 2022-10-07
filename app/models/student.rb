class Student < ApplicationRecord
    has_many :enrollments, dependent: :destroy
end
