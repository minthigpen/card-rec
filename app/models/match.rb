class Match < ApplicationRecord

  belongs_to :card
  belongs_to :background
  belongs_to :rule

  def self.beta_sample(a,b)
    # return sampling score
    SimpleRandom.new.beta(a, b)
  end

end
