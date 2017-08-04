class MatchPresenter
  attr_reader :match, :swatch_presenter, :beta_sample

  delegate :id, :card, :background, :rule, :score, :best_score, to: :match
  delegate :normalized_colors, to: :swatch_presenter



  def initialize(match)
    @match = match
    @swatch_presenter = SwatchPresenter.new(@match.background)
    @beta_sample = @match.beta_sample(@match.alpha, @match.beta)
    @background_id = match.background_id
  end

end
