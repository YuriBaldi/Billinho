class Enrollment < ApplicationRecord
    belongs_to :institution
    belongs_to :student
end
