class Favorite < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :etf, dependent: :destroy
end
