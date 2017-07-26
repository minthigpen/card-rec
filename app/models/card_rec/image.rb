module CardRec
  class Image < ApplicationRecord

   has_many :colors
   # has_many :labels

  end
end
