class ChangeForeignKeyForPayments < ActiveRecord::Migration[7.0]
  def change
    rename_column :payments, :enrollments_id, :enrollment_id
  end
end
