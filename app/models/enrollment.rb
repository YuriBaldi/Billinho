class Enrollment < ApplicationRecord
    belongs_to :institution
    belongs_to :student
    has_many :payment, dependent: :delete_all
    validates_presence_of :course_name, :institution_id, :student_id, :course_price, :number_payments, :due_day
    validates :course_price, numericality: { greater_than: 0, message: 'must be greater than 0' }
    validates :number_payments, numericality: { in: 1..120 }
    validates :due_day, numericality: { in: 1..31 }

    after_create :create_payments

    def enrollment_info
        "Enroll id: #{id} - #{student.name} - #{course_name}"
    end

    def create_payments
        payment_value = course_price.to_f / number_payments
        current_date = Date.today
        payment_due_date = Date.new(current_date.year, current_date.mon, due_day)

        payment_due_date = payment_due_date.next_month if due_day <= current_date.mday

        (1..number_payments).each do
            Payment.create(payment_params(payment_value, payment_due_date, id))
            payment_due_date = payment_due_date.next_month
        end
    end

    def payment_params(payment_value, payment_due_date, enroll_id)
        {
          value: payment_value,
          due_date: payment_due_date,
          status: 'open',
          enrollment_id: enroll_id
        }
    end
end
