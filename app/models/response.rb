class Response < ApplicationRecord

	belongs_to :survey
  has_one :match

end

