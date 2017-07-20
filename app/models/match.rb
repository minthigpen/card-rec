class Match < ApplicationRecord

  belongs_to :card
  belongs_to :background
  belongs_to :rule


  private

  # convert HSV values to RGB values
  def hsv_to_rgb (colors)
    # H, S and V input range = 0 ÷ 1.0
    # R, G and B output range = 0 ÷ 255

    # if ( S == 0 )
    # {
    #    R = V * 255
    #    G = V * 255
    #    B = V * 255
    # }
    # else
    # {
    #    var_h = H * 6
    #    if ( var_h == 6 ) var_h = 0      # H must be < 1
    #    var_i = int( var_h )             # Or ... var_i = floor( var_h )
    #    var_1 = V * ( 1 - S )
    #    var_2 = V * ( 1 - S * ( var_h - var_i ) )
    #    var_3 = V * ( 1 - S * ( 1 - ( var_h - var_i ) ) )

    #    if      ( var_i == 0 ) { var_r = V     ; var_g = var_3 ; var_b = var_1 }
    #    else if ( var_i == 1 ) { var_r = var_2 ; var_g = V     ; var_b = var_1 }
    #    else if ( var_i == 2 ) { var_r = var_1 ; var_g = V     ; var_b = var_3 }
    #    else if ( var_i == 3 ) { var_r = var_1 ; var_g = var_2 ; var_b = V     }
    #    else if ( var_i == 4 ) { var_r = var_3 ; var_g = var_1 ; var_b = V     }
    #    else                   { var_r = V     ; var_g = var_1 ; var_b = var_2 }

    #    R = var_r * 255
    #    G = var_g * 255
    #    B = var_b * 255
    # }

  end

  # input two HSV tuples (h0,s0,v0) and (h1,s1,v1)
  def get_color_diff
    # distance between two hues
    # dh = min(abs(h1-h0), 360-abs(h1-h0)) / 180.0
    # ds = abs(s1-s0)
    # dv = abs(v1-v0) / 255.0

    # Each of these values will be in the range [0,1]. You can compute the length of this tuple:

    # distance = sqrt(dh*dh+ds*ds+dv*dv)
  end



end
