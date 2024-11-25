class CreateContributions < ActiveRecord::Migration[7.1]
  def change
    create_table :contributions do |t|
      t.float :amount
      t.date :date
      t.boolean :paid
      t.references :investment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
