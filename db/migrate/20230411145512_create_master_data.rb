class CreateMasterData < ActiveRecord::Migration
  def change
    create_table :master_data do |t|
      t.string :type
      t.string :key
      t.string :value
      t.boolean :status

      t.timestamps null: false
    end
  end
end
