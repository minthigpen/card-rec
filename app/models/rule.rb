class Rule < ApplicationRecord

  # define all constants here
  PIX_FRAC_THRESHOLD = 0.001
  SCORE_THRESHOLD = 0.01


  def self.get_color_diff (rgb_color1, rgb_color2)
    # make dummy rgb object
    @dummy_rgb ||= Color::RGB.new(0,0,0)
    # convert RGB objects to CIE Lab Objects
    lab_color1 = rgb_color1.to_lab
    lab_color2 = rgb_color2.to_lab
    # return difference
    @dummy_rgb.delta_e94(lab_color1, lab_color2)

  end


  # get a card's color profile and find a backdrop that is the most closely associated to 
  # the complementary color of the card's 'main color'
  def self.compl_color(card, background)

    # if gray scale, just show the opposite end of scale

    # there are several different colors that you could find the complement of - either the most highest score color or highest pixel fraction color 
      # though edge case is that often the most dominant colors are the white background of a card. make this a method so that you can reuse for analagous

    # get the most dominant colors for cards and backgrounds
    card_colors = card.colors.where('pixel_fraction > ?', PIX_FRAC_THRESHOLD).where('score > ?', SCORE_THRESHOLD).to_a
    background_colors = background.colors.where('pixel_fraction > ?', PIX_FRAC_THRESHOLD).where('score > ?', SCORE_THRESHOLD).to_a

    rand
    # # get the card and background color with the highest score and convert to hsv
    # best_card_color = get_best_color_hsv(card.colors)
    # best_background_color = get_best_color_hsv(background.colors)

    # # get the hue of the complimentary color 
    # comp_hue = (best_card_color.first + 180) % 360
    # # also get the comp_value and comp_saturation ***********

    # # if card color is lighter than
    # card_color = [comp_hue, best_card_color[1],best_card_color[2]]
    # puts "HSV best card color is #{best_card_color}"
    # puts "HSV best background color is #{best_background_color}"
    # puts "HSV for COMPLEMENTARY COLOR IS #{card_color}"

    # # get difference of colors and that's the score
    # cd = get_color_diff(card_color,best_background_color)



  end

  def self.similarity(card, background)
    # sort colors related to card and background by score
    card_colors = card.colors.sort{|a, b| a.score <=> b.score}
    background_colors = background.colors.sort {|a, b| a.score <=> b.score}

    # turn into rgb objects
    card_rgb = to_rgb_obj(card_colors)
    background_rgb = to_rgb_obj(background_colors)

    # get the color differences of the most dominant colors and average them 
    diff_colors_array = []

    0.upto([card_rgb.size, background_rgb.size].min - 1) do |index|
      diff_colors_array << get_color_diff(card_rgb[index][0], background_rgb[index][0])
    end

    diff_colors_array.inject(:+).to_f / diff_colors_array.size
  end

  def self.highlight(card, background)
    # # highlights just take the color that is the most dominant (regardless of pixel fraction and picks a background that highlights this color
    card_highlight_color = card.colors.max_by(&:score)
    background_highlight_color = background.colors.max_by(&:score)

    card_highlight_rgb = Color::RGB.new(card_highlight_color.red.to_i, card_highlight_color.green.to_i, card_highlight_color.blue.to_i)
    background_highlight_rgb = Color::RGB.new(background_highlight_color.red.to_i, background_highlight_color.green.to_i, background_highlight_color.blue.to_i)

    get_color_diff(card_highlight_rgb, background_highlight_rgb)

  end

  def self.analogous_color(card, background)
     # get the card and background color with the highest score and convert to hsv
    # best_card_color = get_best_color_hsv(card.colors)
    # best_background_color = get_best_color_hsv(background.colors)

    # # get the hue of the two analogous colors 
    # analogous_hues = [(best_card_color.first + 30) % 360,(best_card_color.first - 30).abs % 360]


    # acolor1 = [analogous_hues[0], best_card_color[1],best_card_color[2]]
    # acolor2 = [analogous_hues[1], best_card_color[1],best_card_color[2]]

    # # get difference of the two analogous colors and get the lowest score
    # cd1 = get_color_diff(acolor1,best_background_color)
    # cd2 = get_color_diff(acolor2,best_background_color)

    # [cd1,cd2].min
    rand
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

  # helper method to return array of RGB objects
  def self.to_rgb_obj (color_profile)
    color_profile.map do |color|
      [Color::RGB.new(color.red.to_i, color.green.to_i, color.blue.to_i), color.score, color.pixel_fraction]
    end
  end

end
