class Investment < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :etf, dependent: :destroy
  has_many :contributions
end
