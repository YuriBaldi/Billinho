json.extract! payment, :id, :value, :due_date, :status, :created_at, :updated_at
json.url payment_url(payment, format: :json)
