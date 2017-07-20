class Match < ApplicationRecord

  belongs_to :card
  belongs_to :background
  belongs_to :rule


  private



  # input two HSV tuples (h0,s0,v0) and (h1,s1,v1)
  def get_color_diff(hue1,hue2)
    h0,s0,v0 = hue1[0],hue1[1], hue1[2]
    h1,s1,v1 = hue2[0],hue2[1], hue2[2]
    # distance between two hues
    dh = (((h1-h0).abs,(360-(h1-h0).abs)).min)/180.0
    ds = (s1-s0).abs
    dv = (v1-v0).abs / 255.0

    # Each of these values will be in the range [0,1]. You can compute the length of this tuple:

    distance = Math.sqrt(dh*dh+ds*ds+dv*dv)
  end



end
