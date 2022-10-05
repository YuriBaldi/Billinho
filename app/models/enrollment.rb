class Enrollment < ApplicationRecord
    belongs_to :institution 
    belongs_to :student
    validates_presence_of :course_name, :institution_id, :student_id, :total_course, :number_payments, :due_day
    validates :number_payments, numericality: { in: 1..120 }
    validates :due_day, numericality: { in: 1..31 }

    after_create :create_enrollment

    def create_enrollment()
        payment_value = self.course_price.to_f / self.number_payments
        current_date = Date.today
        payment_due_date = Date.new(current_date.year, current_date.mon, self.due_day)

        if self.due_day <= current_date.mday
            payment_due_date = payment_due_date.next_month
        end

        for n in 1..self.number_payments
            Payment.create(
                value: payment_value,
                due_date: payment_due_date,
                status: "open",
                enrollment_id: self.id
            )
            payment_due_date = payment_due_date.next_month
        end
    end
end
