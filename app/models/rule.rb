class Rule < ApplicationRecord

  # define all constants here
  PIX_FRAC_THRESHOLD = 0.001
  SCORE_THRESHOLD = 0.01

  # get a card's color profile and find a backdrop that is the most closely associated to 
  # the complementary color of the card's 'main color'
  def self.compl_color(card, background)

    # sort card colors by score to get the 'main focus' color of the card since a lot of cards are on white backgrounds
    card_colors = card.colors.sort{|a, b| a.score <=> b.score}.reverse!
    # sort background colors by pixel fraction since backgrounds are simpler
    background_colors = background.colors.sort {|a, b| a.pixel_fraction <=> b.pixel_fraction}.reverse!

    # convert to HSL in order to get the complement color
    compl_card_color = Color::RGB.new(card_colors.first.red.to_i, card_colors.first.green.to_i, card_colors.first.blue.to_i).to_hsl
    compl_card_color.hue=(compl_card_color.hue+180)

    # get the difference of the target complementary color for the main card color and the background color with the highest pixel fraction
    best_background_color = Color::RGB.new(background_colors.first.red.to_i, background_colors.first.green.to_i, background_colors.first.blue.to_i)
    get_color_diff(compl_card_color.to_rgb, best_background_color)

    # # also get the comp_value and comp_saturation *********** --> this might be implemented in contrast

  end

  # Match a card and background based on the color profiles for each that has the highest score 
  # maybe include proportionality ?
  def self.similarity(card, background)
    # sort colors related to card and background by score and reverse to get a descending list
    card_colors = card.colors.sort{|a, b| a.score <=> b.score}.reverse!
    background_colors = background.colors.sort {|a, b| a.score <=> b.score}.reverse!
    # turn into rgb objects
    card_rgb = to_rgb_obj(card_colors)
    background_rgb = to_rgb_obj(background_colors)

    # get the color differences of the most dominant colors
    diff_colors_array = []
    0.upto([card_rgb.size, background_rgb.size].min - 1) do |index|
      diff_colors_array << get_color_diff(card_rgb[index][0], background_rgb[index][0])
    end
    # return the average of the array
    diff_colors_array.inject(:+).to_f / diff_colors_array.size
  end

  # Get a card's highlight color based on the second highest pixel_fraction and match it with a the highest scored background color
  def self.highlight(card, background)
    # highlights just take the color that is the most dominant (regardless of pixel fraction and picks a background that highlights this color
    # sort colors related to card and background by score
    card_colors = card.colors.sort{|a, b| a.pixel_fraction <=> b.pixel_fraction}.reverse!
    background_colors = background.colors.sort {|a, b| a.score <=> b.score}.reverse!
    # convert the sorted array to an array of RGB objects
    # card_rgb = to_rgb_obj(card_colors.last)
    background_rgb = to_rgb_obj([background_colors.first])
    # set the card highlight color as card color with the second most pixel fraction if the array contains more than one color
    # card_rgb.size > 1 ? card_highlight_rgb = card_rgb[1][0] : card_highlight_rgb = card_rgb[0][0]
    card_highlight_rgb = to_rgb_obj([card_colors.last])
    # compare the card highlight color to the main background rgb color with highest score
    get_color_diff(card_highlight_rgb[0][0], background_rgb[0][0])

  end

  # Get a card's color profile and find a backdrop that is the most closely associated to 
  # the analogous colors of the card's 'main color'
  def self.analogous_color(card, background)
    # sort card colors by score to get the 'main focus' color of the card since a lot of cards are on white backgrounds
    card_colors = card.colors.sort{|a, b| a.score <=> b.score}.reverse!
    # sort background colors by pixel fraction since backgrounds are simpler
    background_colors = background.colors.sort {|a, b| a.pixel_fraction <=> b.pixel_fraction}.reverse!
    background_rgb = to_rgb_obj(background_colors)
    # convert to HSL in order to get the two analogous colors
    analog_card_color1 = Color::RGB.new(card_colors.first.red.to_i, card_colors.first.green.to_i, card_colors.first.blue.to_i).to_hsl
    analog_card_color2 = Color::RGB.new(card_colors.first.red.to_i, card_colors.first.green.to_i, card_colors.first.blue.to_i).to_hsl
    analog_card_color1.hue=(analog_card_color1.hue+30)
    analog_card_color2.hue=(analog_card_color2.hue-30)

    # convert back to array of RGB objects
    analog_card_colors = [analog_card_color1.to_rgb, analog_card_color2.to_rgb]
    # get difference of the two analogous colors with the best background color and get the lowest score
    diff = []
    analog_card_colors.each do |a_color|
      diff << get_color_diff(a_color, background_rgb[0][0])
    end
    diff.min
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

  # helper method to get color difference of two RGB objects
  def self.get_color_diff (rgb_color1, rgb_color2)
    # make dummy rgb object
    @dummy_rgb ||= Color::RGB.new(0,0,0)
    # convert RGB objects to CIE Lab Objects
    lab_color1 = rgb_color1.to_lab
    lab_color2 = rgb_color2.to_lab
    # return difference
    @dummy_rgb.delta_e94(lab_color1, lab_color2)
  end

end
