json.extract! enrollment, :id, :course_price, :number_payments, :due_day, :course_name, :created_at, :updated_at
json.url enrollment_url(enrollment, format: :json)
