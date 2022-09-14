json.extract! student, :id, :name, :cpf, :birth_date, :phone, :gender, :payment_type, :created_at, :updated_at
json.url student_url(student, format: :json)
