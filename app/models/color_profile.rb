class ColorProfile < ApplicationRecord

 belongs_to :image
  # use ::Color module to convert to HSV
  
end