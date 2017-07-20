class Rule < ApplicationRecord

  # get a card's color profile and find a backdrop that is the most closely associated to 
  # the complementary color of the card's 'main color'
  def self.compl_color(card, background)

    # card_colors = Card.colors with only the profiles above 0.01
    # main_colors = the color profile that has the greatest pixel fraction from card_colors
  
    # hsv_colors = rgb_to_hsv (main_colors)
    # card_hsv_color = card.dominant_color.to_hsv
    # take the most dominant color and compute the complimentary color

    # color_matches = []

    # loops through all backdrops 
      # get average color
      # cd = get_color_diff (complimentary color and backdrop average color)
      # store cd into array with associated backdrop
    
    # return the array
    rand
    
  end

  def self.similarity(card, background)
    rand

  end

  def self.highlight(card, background)
    rand

  end

  def self.analogous_color(card, background)
    rand
  end

  def self.contrast(card, background)
    rand
  end

end
