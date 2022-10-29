class Enrollment < ApplicationRecord
    belongs_to :institution
    belongs_to :student
    has_many :payment, dependent: :delete_all
    validates_presence_of :course_name, :institution_id, :student_id, :course_price, :number_payments, :due_day
    validates :course_price, numericality: { greater_than: 0, message: 'must be greater than 0' }
    validates :number_payments, numericality: { in: 1..120 }
    validates :due_day, numericality: { in: 1..31 }

    after_create :create_payments
    after_update :update_payments

    def enrollment_info
        "Enroll id: #{id} - #{student.name} - #{course_name}"
    end

    def create_payments
        payment_value = course_price.to_f / number_payments
        payment_due_date = get_due_date(Date.today, due_day)

        (1..number_payments).each do
            Payment.create(payment_params(payment_value, payment_due_date, id))
            payment_due_date = get_due_date(payment_due_date.next_month, due_day)
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

    def get_due_date(current_date, due_day)
        if Date.valid_date?(current_date.year, current_date.month, due_day)
            payment_due_date = Date.new(current_date.year, current_date.mon, due_day)
        else
            payment_due_date = current_date.end_of_month
        end
        payment_due_date = get_due_date(payment_due_date.next_month, due_day) if payment_due_date <= Date.today
        payment_due_date
    end

    def update_payments
        if previous_changes.key?("due_day")
            payments = Payment.where(enrollment_id: id, status: 'open').all
            payments.each do |payment|
                payment.due_date = get_due_date(payment.due_date, due_day)
                payment.save
            end
        end
    end
end
