class Match < ApplicationRecord

  belongs_to :card
  belongs_to :background
  belongs_to :rule

  def beta_samp(a,b)
    # return sampling score
    SimpleRandom.new.beta(a, b)
  end

end
