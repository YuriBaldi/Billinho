class CreateEnrollments < ActiveRecord::Migration[7.0]
  def change
    create_table :enrollments do |t|
      t.decimal :course_price
      t.integer :number_payments
      t.integer :due_day
      t.string :course_name

      t.timestamps
    end
  end
end
