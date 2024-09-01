class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :partner, index: true, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.decimal :fee_rate
      t.text :note

      t.timestamps null: false
    end
  end
end
