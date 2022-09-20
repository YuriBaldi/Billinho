class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.decimal :value
      t.date :due_date
      t.string :status

      t.timestamps
    end
  end
end
