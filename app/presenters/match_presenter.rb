class MatchPresenter

  def initialize(match)
    @match = options[:match]
    @swatch_presenter = SwatchPresenter.new(@match.background)
  end

end
