class CreateInvestments < ActiveRecord::Migration[7.1]
  def change
    create_table :investments do |t|
      t.string :name
      t.string :description
      t.references :user, null: false, foreign_key: true
      t.references :etf, null: false, foreign_key: true
      t.string :risk_level

      t.timestamps
    end
  end
end
