class AddEnrollmentIdToPayments < ActiveRecord::Migration[7.0]
  def change
    add_reference :payments, :enrollments, null: false, foreign_key: true
  end
end
