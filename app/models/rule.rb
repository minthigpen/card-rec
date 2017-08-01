class Rule < ApplicationRecord

  # define all constants here
  PIX_FRAC_THRESHOLD = 0.001
  SCORE_THRESHOLD = 0.01

  def self.random(card, background)
    rand
  end

  # get a card's color profile and find a backdrop that is the most closely associated to 
  # the complementary color of the card's 'main color'
  def self.compl_color(card, background)
    # sort card colors by score to get the 'main focus' color of the card since a lot of cards are on white backgrounds
    card_colors_hsl = to_hsl(card.colors.sort{|a, b| b.score <=> a.score})
    # sort background colors by pixel fraction since backgrounds are simpler
    background_colors = background.colors.sort {|a, b| b.pixel_fraction <=> a.pixel_fraction}
    # takes out the color in the array of card colors that is close to 'white'
    card_colors_hsl.reject! do |color|
      color.saturation < 10 && color.luminosity > 90
    end
    # without the white color, assuming the list of card colors are ranked by score
    main_card_color = card_colors_hsl.first

    # change the hue, saturation and luminosity of main card
    main_card_color.hue=(main_card_color.hue-180)
    main_card_color.luminosity=(50)
    main_card_color.saturation=(100)

    puts "COMPLEMENTARY COLOR is #{main_card_color.hue}, #{main_card_color.saturation}, #{main_card_color.luminosity} "
    compl_card_color = main_card_color

    # convert the saturation/lightness of the background in order to get a consistent difference using delta E
    best_background_color = Color::RGB.new(background_colors.first.red.to_i, background_colors.first.green.to_i, background_colors.first.blue.to_i)
    background_hsl = best_background_color.to_hsl
    background_hsl.luminosity=(50)
    background_hsl.saturation=(100)
    background_rgb = background_hsl.to_rgb

    # get the difference of the target complementary color for the main card color and the background color with the highest pixel fraction
    get_color_diff(compl_card_color.to_rgb, background_rgb)


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

    # convert card colors to RGB and then to HSL
    card_colors.map! do |color|
      Color::RGB.new(color.red.to_i, color.green.to_i, color.blue.to_i).to_hsl
    end
    # set the highlight color to be the color with highest saturation
    card_highlight_rgb = card_colors.max_by(&:saturation).to_rgb

    # compare the card highlight color to the main background rgb color with highest score
    get_color_diff(card_highlight_rgb, background_rgb[0][0])
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
    # set HSL for analogous color 1
    analog_card_color1.hue=(analog_card_color1.hue+30)
    analog_card_color1.luminosity=(50)
    analog_card_color1.saturation=(100)
    # set HSL for analogous color 2
    analog_card_color2.hue=(analog_card_color2.hue-30)
    analog_card_color2.luminosity=(50)
    analog_card_color2.saturation=(100)

    background_hsl = background_rgb[0][0].to_hsl
    background_hsl.luminosity=(50)
    background_hsl.saturation=(100)
    background_rgb = background_hsl.to_rgb

    # convert back to array of RGB objects
    analog_card_colors = [analog_card_color1.to_rgb, analog_card_color2.to_rgb]
    # get difference of the two analogous colors with the best background color and get the lowest score
    diff = []
    analog_card_colors.each do |a_color|
      diff << get_color_diff(a_color, background_rgb)
    end
    diff.min

    # get_color_diff(analog_card_color1.to_rgb, background_rgb[0][0])
  end

  def self.contrast(card, background)
    # highest contrast comes from getting the a combination of Hue and Saturation and Lightness
    card_colors = card.colors.sort{|a, b| a.pixel_fraction <=> b.pixel_fraction}.reverse!
    background_colors = background.colors.sort {|a, b| a.pixel_fraction <=> b.pixel_fraction}.reverse!
    background_rgb = to_rgb_obj(background_colors)

    main_card_color = card_colors.first
    contrast_color_hsl = Color::RGB.new(main_card_color.red,main_card_color.green,main_card_color.blue).to_hsl
    
    # if it's darker then lighten
    if contrast_color_hsl.luminosity < 50
      contrast_color_hsl.luminosity=(contrast_color_hsl.luminosity+50)
    # else if it's lighter then darken
    else
      contrast_color_hsl.luminosity=(contrast_color_hsl.luminosity-50)
    end

    # if there is color then adjust saturation
    if contrast_color_hsl.saturation != 0
      if contrast_color_hsl.saturation < 50
        contrast_color_hsl.saturation=(contrast_color_hsl.saturation+50)
      else
        contrast_color_hsl.saturation=(contrast_color_hsl.saturation-50)
      end
      # also adjust the hue
      contrast_color_hsl.hue=(contrast_color_hsl.hue-180)
    end
    # does this account for neutrals?
    get_color_diff(contrast_color_hsl.to_rgb, background_rgb[0][0])
  end

  # helper method to return array of RGB objects
  def self.to_rgb_obj(color_profiles)
    color_profiles.map do |color|
      [Color::RGB.new(color.red.to_i, color.green.to_i, color.blue.to_i), color.score, color.pixel_fraction]
    end
  end

  def self.to_hsl(color_profiles)
    color_profiles.map do |color|
      Color::RGB.new(color.red.to_i, color.green.to_i, color.blue.to_i).to_hsl
    end
  end

  # helper method to get color difference of two RGB objects
  def self.get_color_diff(rgb_color1, rgb_color2)
    # make dummy rgb object
    @dummy_rgb ||= Color::RGB.new(0,0,0)
    # convert RGB objects to CIE Lab Objects
    lab_color1 = rgb_color1.to_lab
    lab_color2 = rgb_color2.to_lab
    # return difference with Ruby gem for Color
    @dummy_rgb.delta_e94(lab_color1, lab_color2)
    # puts (@dummy_rgb.delta_e94(lab_color1, lab_color2))
    # return the difference with just manual computation

    # k_1 = 0.045
    # k_2 = 0.015
    # k_L = 1

    # k_C = k_H = 1

    # l_1, a_1, b_1 = lab_color1.values_at(:L, :a, :b)
    # puts ("#{l_1},#{a_1},#{b_1}")
    # l_2, a_2, b_2 = lab_color2.values_at(:L, :a, :b)

    # delta_a = a_1 - a_2
    # delta_b = b_1 - b_2

    # c_1 = Math.sqrt((a_1 ** 2) + (b_1 ** 2))
    # c_2 = Math.sqrt((a_2 ** 2) + (b_2 ** 2))

    # delta_L = lab_color1[:L] - lab_color2[:L]
    # delta_C = c_1 - c_2

    # delta_H2 = (delta_a ** 2) + (delta_b ** 2) - (delta_C ** 2)

    # s_L = 1
    # s_C = 1 + k_1 * c_1
    # s_H = 1 + k_2 * c_1

    # composite_L = (delta_L / (k_L * s_L)) ** 2
    # composite_C = (delta_C / (k_C * s_C)) ** 2
    # composite_H = delta_H2 / ((k_H * s_H) ** 2)
    # puts (Math.sqrt(composite_L + composite_C + composite_H))
    # Math.sqrt(composite_L + composite_C + composite_H)


  end

end
