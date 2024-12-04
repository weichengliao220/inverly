class AddLastFetchedAtToHoldings < ActiveRecord::Migration[7.1]
  def change
    add_column :holdings, :last_fetched_at, :datetime
  end
end
