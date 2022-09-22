class ChangeColumnDefault < ActiveRecord::Migration[7.0]
  def change
    change_column :payments, :status, :string, default: "open"
  end
end
