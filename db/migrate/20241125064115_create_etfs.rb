class CreateEtfs < ActiveRecord::Migration[7.1]
  def change
    create_table :etfs do |t|
      t.string :name
      t.string :ticker_symbol
      t.string :category
      t.string :description
      t.string :historical_data
      t.integer :current_price
      t.float :average_return

      t.timestamps
    end
  end
end
