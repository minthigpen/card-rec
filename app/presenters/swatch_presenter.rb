class SwatchPresenter
  attr_reader :normalized_colors

  def initialize(image)
    colors = image.colors.sort{ |color_1, color_2| color_2.pixel_fraction <=> color_1.pixel_fraction }
    
    fraction_sum = colors.sum(&:pixel_fraction)
    multiplier = 1.0 / fraction_sum
    @normalized_colors = colors.map do |color|
      color_dup = color.dup
      color_dup.pixel_fraction = color.pixel_fraction * multiplier
      color_dup
    end
  end

end