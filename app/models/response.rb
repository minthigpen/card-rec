class Response < ApplicationRecord

	belongs_to :survey
  has_on :match

end

