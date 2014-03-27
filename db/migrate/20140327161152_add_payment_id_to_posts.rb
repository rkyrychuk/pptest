class AddPaymentIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :payment_id, :integer
  end
end
