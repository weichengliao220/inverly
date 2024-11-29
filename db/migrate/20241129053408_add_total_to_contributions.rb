class AddTotalToContributions < ActiveRecord::Migration[7.1]
  def change
    add_column :contributions, :total, :float
  end
end
