class Contribution < ApplicationRecord
  belongs_to :investment, dependent: :destroy
end
