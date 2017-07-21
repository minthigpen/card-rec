class Survey < ApplicationRecord
  has_many :responses
  belongs_to :card
  after_create :init_responses

  # after initialize and save
  def init_responses
    self.card.best_matches.each do |m|
      self.responses.new(card_id: m.card_id, rule_id: m.rule_id, selected: false)
    end
  end
end
