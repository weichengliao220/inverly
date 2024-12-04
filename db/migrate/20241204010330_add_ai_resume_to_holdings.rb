class AddAiResumeToHoldings < ActiveRecord::Migration[7.1]
  def change
    add_column :holdings, :ai_resume, :string
  end
end
