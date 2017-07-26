module CardRec
  class Survey < ApplicationRecord
    has_many :responses
    belongs_to :card

  end
end
