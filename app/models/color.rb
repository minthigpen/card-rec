class ColorProfile < ApplicationRecord

 belongs_to :image
  # use ::Color module to convert to HSV
  def to_hsv
    rgb_obj = ::Color::RGB.new(Color.red, Color.green, Color.blue)

    # hsv_obj = rgb_obj.
    # # R, G and B input range = 0 ÷ 255
    # # H, S and V output range = 0 ÷ 1.0

    # hsv = Array.new

    # var_R = (red / 255)
    # var_G = (green / 255)
    # var_B = (blue / 255)

    # var_Min = [var_R, var_G, var_B].min    # Min. value of RGB
    # var_Max = [var_R, var_G, var_B].max    # Max. value of RGB
    # del_Max = var_Max - var_Min             # Delta RGB value

    # v = var_Max

    # if del_Max == 0                     # This is a gray, no chroma...
    
    #   h = 0
    #   s = 0
    
    # else                                    # Chromatic data...
    
    #   s = del_Max / var_Max

    #   del_R = ( ( ( var_Max - var_R ) / 6 ) + ( del_Max / 2 ) ) / del_Max
    #   del_G = ( ( ( var_Max - var_G ) / 6 ) + ( del_Max / 2 ) ) / del_Max
    #   del_B = ( ( ( var_Max - var_B ) / 6 ) + ( del_Max / 2 ) ) / del_Max

    #   if var_R == var_Max
    #     h = del_B - del_G
    #   elsif var_G == var_Max
    #     h = ( 1 / 3 ) + del_R - del_B
    #   elsif var_B == var_Max
    #     h = ( 2 / 3 ) + del_G - del_R
    #   end

    #   h+= 1 if h < 0
    #   h-= 1 if h > 1
    # end

    # h = h*360

    # # return tuple in form of [H,S, V]
    # hsv.push(h)
    # hsv.push(s)
    # hsv.push(v)
    # hsv.push(score)
    # hsv.push(pixel_fraction)

    # hsv

  end

end