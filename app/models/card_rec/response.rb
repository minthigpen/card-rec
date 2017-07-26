module CardRec
  class Response < ApplicationRecord

  	belongs_to :survey
    belongs_to :card
    belongs_to :rule


  end
end
