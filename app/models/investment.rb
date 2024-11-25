class Investment < ApplicationRecord
  belongs_to :user
  belongs_to :etf
  has_many :contributions
end
