class AddStudentIdToEnrollments < ActiveRecord::Migration[7.0]
  def change
    add_column :enrollments, :student_id, :integer
    add_index :enrollments, :student_id
  end
end
