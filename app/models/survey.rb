class Survey < ApplicationRecord
  has_many :responses
  belongs_to :card
  # after_create :init_responses

  # # after initialize and save
  # def init_responses
  #   self.card.best_matches.each do |m|
  #     self.responses.new(match_id: m.id, selected: false)
  #   end
  # end
end
