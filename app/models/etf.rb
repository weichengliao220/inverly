class Etf < ApplicationRecord
  has_many :investments
  has_many :favorites
end
