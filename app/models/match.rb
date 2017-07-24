class Match < ApplicationRecord

  belongs_to :card
  belongs_to :background
  belongs_to :rule

end
