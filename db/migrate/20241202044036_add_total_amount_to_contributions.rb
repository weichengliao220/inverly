class AddTotalAmountToContributions < ActiveRecord::Migration[7.1]
  def change
    add_column :contributions, :total_amount, :decimal
  end
end
