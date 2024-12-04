class AddComparedToInvestments < ActiveRecord::Migration[7.1]
  def change
    add_column :investments, :compared, :boolean
  end
end
