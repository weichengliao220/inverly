class Etf < ApplicationRecord
  has_many :investments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user
  has_many :holdings, dependent: :destroy
  has_many :monthly_times, dependent: :destroy

  def self.category
    Etf.all.map(&:category) # Etf.category
  end
end
