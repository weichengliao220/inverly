class Etf < ApplicationRecord
  has_many :investments, dependent: :destroy
  has_many :favorites, dependent: :destroy
end
