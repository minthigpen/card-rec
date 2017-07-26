class Image < ApplicationRecord

 has_many :colors, :class_name => 'ColorProfile'
 # has_many :labels

end

