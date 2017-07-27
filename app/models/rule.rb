class Rule < ApplicationRecord

  # define all constants here
  PIX_FRAC_THRESHOLD = 0.001
  SCORE_THRESHOLD = 0.01

  # get a card's color profile and find a backdrop that is the most closely associated to 
  # the complementary color of the card's 'main color'
  def self.compl_color(card, background)

    # there are several different colors that you could find the complement of - either the most highest score color or highest pixel fraction color 
      # though edge case is that often the most dominant colors are the white background of a card. make this a method so that you can reuse for analagous

    # get the most dominant colors for cards and backgrounds
    card_colors = card.colors.where('pixel_fraction > ?', PIX_FRAC_THRESHOLD).where('score > ?', SCORE_THRESHOLD)
    background_colors = background.colors.where('pixel_fraction > ?', PIX_FRAC_THRESHOLD).where('score > ?', SCORE_THRESHOLD)

    # get the card and background color with the highest score and convert to hsv
    best_card_color = get_best_color_hsv(card.colors)
    best_background_color = get_best_color_hsv(background.colors)

    # get the hue of the complimentary color 
    comp_hue = (best_card_color.first + 180) % 360
    # also get the comp_value and comp_saturation ***********

    # if card color is lighter than
    card_color = [comp_hue, best_card_color[1],best_card_color[2]]
    puts "HSV best card color is #{best_card_color}"
    puts "HSV best background color is #{best_background_color}"
    puts "HSV for COMPLEMENTARY COLOR IS #{card_color}"

    # get difference of colors and that's the score
    cd = get_color_diff(card_color,best_background_color)



  end

  def self.similarity(card, background)
    # need to take into account similar color profile instead of just single color swatch that is the most dominant
    
    # take into account both score and pixel fraction
    # get the most dominant colors for cards and backgrounds
    # card_colors = card.colors.where('pixel_fraction > ?', PIX_FRAC_THRESHOLD).where('score > ?', SCORE_THRESHOLD).order(score: :desc).limit(3)
    # background_colors = background.colors.where('pixel_fraction > ?', PIX_FRAC_THRESHOLD).where('score > ?', SCORE_THRESHOLD).order(score: :desc).limit(3)
    diff = []

    # sort by score
    c = card.colors.sort{|a, b| a.score <=> b.score}
    b = background.colors.sort {|a, b| a.score <=> b.score}
    # sort by pixel fraction
    card_colors_sorted = c.sort_by{ |a| -a.pixel_fraction}

    d = []
    0.upto([c.size, b.size].min - 1) do |index|
      d << get_color_diff(c[index].to_hsv, b[index].to_hsv)
    end


    # c = Array.new
    # b = Array.new
    # # compare the first three ordered by pixel_fraction
    # card_colors.order(pixel_fraction: :desc).each do |card|
    #   c.push(card.to_hsv)
    # end

    # background_colors.order(pixel_fraction: :desc).each do |back|
    #   b.push(back.to_hsv)
    # end

    d.inject(:+).to_f / d.size
  end

  def self.highlight(card, background)
    # highlights just take the color that is the most dominant (regardless of pixel fraction and picks a background that highlights this color
    best_card_color = get_best_color_hsv(card.colors)
    best_background_color = get_best_color_hsv(background.colors)

    # maybe consider lower saturation?
    get_color_diff(best_card_color, best_background_color)

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

    # finds the maximum distance on both H, S, V

    # account for white and black
    # account for greys
    # account for low saturation
    # account of hue difference
    # account for neutrals 
    # account for 


    rand
  end

  # input colors
  def self.get_best_color_hsv (colors)
    # get the color with max score
    best_color = colors.max_by {|x| x.score}
    # convert to hsv
    best_color.to_hsv
  end

    # input two colors from the CIE Lab space
  def self.get_color_diff(hue1, hue2)
    # convert from HSV to RGB to XYZ to CIEL*ab then take the DELTA E using ::Color Module





    # CARTESIAN DISTANCE BETWEEN TWO HSV TUPLES

    h0,s0,v0 = hue1[0],hue1[1], hue1[2]
    h1,s1,v1 = hue2[0],hue2[1], hue2[2]
    # distance between two hues
    dh = [(h1-h0).abs,(360-(h1-h0).abs)].min/180.0

    ds = (s1-s0).abs
    dv = (v1-v0).abs

    # Each of these values will be in the range [0,1]. You can compute the length of this tuple:

    distance = Math.sqrt(dh*dh+ds*ds+dv*dv)
  end



end
