class CreateInstitutions < ActiveRecord::Migration[7.0]
  def change
    create_table :institutions do |t|
      t.string :name, unique: true, null: false
      t.string :cnpj, unique: true, null: false
      t.string :type, unique: true, null: false

      t.timestamps
    end
  end
end
