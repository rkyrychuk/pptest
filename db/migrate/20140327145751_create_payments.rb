class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :token
      t.text :data

      t.timestamps
    end
  end
end
