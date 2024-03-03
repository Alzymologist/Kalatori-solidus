class CreateSolidusKalatoriBlockchainTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :solidus_kalatori_blockchain_transactions do |t|

      t.timestamps
    end
  end
end
