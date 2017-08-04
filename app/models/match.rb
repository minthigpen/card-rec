class Match < ApplicationRecord

  belongs_to :card
  belongs_to :background
  belongs_to :rule

  def beta_sample(a,b)
    # return sampling score
    a == 0 ? a = 1 : a = a.abs
    b == 0 ? b = 1 : b = b.abs
    SimpleRandom.new.beta(a.abs, b.abs)
  end

end
