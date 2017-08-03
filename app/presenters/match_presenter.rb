class MatchPresenter
  attr_reader :match, :swatch_presenter, :beta_samp

  delegate :id, :card, :background, :rule, :score, :best_score, to: :match
  delegate :normalized_colors, to: :swatch_presenter



  def initialize(match)
    @match = match
    @swatch_presenter = SwatchPresenter.new(@match.background)
    @beta_sample = beta_sample(@match.a, @match.b)
  end

end
