class CreateSolidusKalatoriBlockchainTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :solidus_kalatori_blockchain_transactions do |t|
      t.string :blockchain_address, null: false #, index: { unique: true }
      t.timestamps
    end

    add_reference :solidus_kalatori_blockchain_transactions, :payment_method, foreign_key: { to_table: :spree_payment_methods }, index: true
  end
end
