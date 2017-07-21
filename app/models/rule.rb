class Rule < ApplicationRecord

  # define all constants here
  PIX_FRAC_THRESHOLD = 0.001
  SCORE_THRESHOLD = 0.01

  # get a card's color profile and find a backdrop that is the most closely associated to 
  # the complementary color of the card's 'main color'
  def self.compl_color(card, background)

    # get the most dominant colors for cards and backgrounds
    # card_colors = card.colors.where('pixel_fraction > ?', PIX_FRAC_THRESHOLD).where('score > ?', SCORE_THRESHOLD)
    # background_colors = background.colors.where('pixel_fraction > ?', PIX_FRAC_THRESHOLD).where('score > ?', SCORE_THRESHOLD)

    # get the card and background color with the highest score and convert to hsv
    best_card_color = get_best_color_hsv(card.colors)
    best_background_color = get_best_color_hsv(background.colors)

    # get the hue of the complimentary color 
    comp_hue = (best_card_color.first + 180) % 360

    card_color = [comp_hue, best_card_color[1],best_card_color[2]]

    # get difference of colors and that's the score
    get_color_diff(card_color,best_background_color)

  end

  def self.similarity(card, background)
    # get the card and background color with the highest score and convert to hsv
    best_card_color = get_best_color_hsv(card.colors)
    best_background_color = get_best_color_hsv(background.colors)

    # maybe consider lower saturation?
    get_color_diff(best_card_color, best_background_color)

  end

  def self.highlight(card, background)
    # get the card and background color with the highest score and convert to hsv
    # best_card_color = get_best_color_hsv(card.colors)
    # best_background_color = get_best_color_hsv(background.colors)
    rand
  end

  def self.analogous_color(card, background)
     # get the card and background color with the highest score and convert to hsv
    best_card_color = get_best_color_hsv(card.colors)
    best_background_color = get_best_color_hsv(background.colors)

    # get the hue of the two analogous colors 
    analogous_hues = [(best_card_color.first + 30) % 360,(best_card_color.first - 30).abs % 360]


    acolor1 = [analogous_hues[0], best_card_color[1],best_card_color[2]]
    acolor2 = [analogous_hues[1], best_card_color[1],best_card_color[2]]

    # get difference of the two analogous colors and get the lowest score
    cd1 = get_color_diff(acolor1,best_background_color)
    cd2 = get_color_diff(acolor2,best_background_color)

    [cd1,cd2].min
  end

  def self.contrast(card, background)
    # highest contrast comes from getting the a combination of Hue and Saturation and Lightness
    rand
  end

  # input colors
  def self.get_best_color_hsv (colors)
    # get the color with max score
    best_color = colors.max_by {|x| x.score}
    # convert to hsv
    best_color.to_hsv

  end
    # input two HSV tuples (h0,s0,v0) and (h1,s1,v1)
  def self.get_color_diff(hue1,hue2)
    h0,s0,v0 = hue1[0],hue1[1], hue1[2]
    h1,s1,v1 = hue2[0],hue2[1], hue2[2]
    # distance between two hues
    dh = [(h1-h0).abs,(360-(h1-h0).abs)].min/180.0
    puts dh
    ds = (s1-s0).abs
    dv = (v1-v0).abs/255.0

    # Each of these values will be in the range [0,1]. You can compute the length of this tuple:

    distance = Math.sqrt(dh*dh+ds*ds+dv*dv)
  end



end
