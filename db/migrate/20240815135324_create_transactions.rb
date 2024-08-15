class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions, id: false do |t|
      t.bigint :transaction_id, null: false, primary_key: true
      t.bigint :merchant_id
      t.bigint :user_id
      t.string :card_number
      t.datetime :transaction_date
      t.decimal :transaction_amount, precision: 15, scale: 2
      t.bigint :device_id
      t.boolean :has_cbk, default: false, null: false

      t.timestamps
    end

    add_index :transactions, :user_id
    add_index :transactions, :transaction_amount
  end
end
