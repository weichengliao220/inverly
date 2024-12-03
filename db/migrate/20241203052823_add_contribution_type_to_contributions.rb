class AddContributionTypeToContributions < ActiveRecord::Migration[7.1]
  def change
    add_column :contributions, :contribution_type, :string
  end
end
