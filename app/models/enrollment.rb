class Enrollment < ApplicationRecord
    belongs_to :institution 
    belongs_to :student
    validates_presence_of :course_name, :institution_id, :student_id, :total_course, :number_payments, :due_day
    validates :number_payments, numericality: { in: 1..120 }
    validates :due_day, numericality: { in: 1..31 }
end
