class RemoveOlderForeignKeyForPayments < ActiveRecord::Migration[7.0]
  def change
    remove_column :payments, :enrollments_id
  end
end
