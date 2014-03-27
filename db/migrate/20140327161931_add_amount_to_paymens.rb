class AddAmountToPaymens < ActiveRecord::Migration
  def change
    add_column :payments, :amount, :decimal, :precision => 10, :scale => 2
    add_column :payments, :completed, :boolean
    add_column :payments, :canceled, :boolean
  end
end
