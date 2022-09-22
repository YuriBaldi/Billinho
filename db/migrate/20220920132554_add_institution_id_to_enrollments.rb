class AddInstitutionIdToEnrollments < ActiveRecord::Migration[7.0]
  def change
    add_column :enrollments, :institution_id, :integer
    add_index :enrollments, :institution_id
  end
end
