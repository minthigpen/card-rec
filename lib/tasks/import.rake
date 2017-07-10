namespace :import do

  def import_page_json(klass, url, page_num = 1)
    source = "#{url}?page=#{page_num}"
    resp = Net::HTTP.get_response(URI.parse(source))
    data = resp.body
    result = JSON.parse(data)
    images = result[klass == Background ? "card_backgrounds" : "records"]

    images.each do |img|
      klass.create(url: img["image_url"], pp_id: img["id"])
    end

    result["total_pages"]
  end

  def import_color_profile (klass)
    # Google Vision API project-id and requirements (authorized through Google SDK login)
    require "google/cloud/vision"
    project_id = "backdrop-rec"
    # set up a new client
    vision = Google::Cloud::Vision.new project: project_id
    counter = 1
    # for each object in the Background class get color data and insert them into 
    # Color table to be associated with each background
    klass.all.each do |k|
      url = k.url
      puts "Importing color profile number #{counter} of #{klass}"
      # set_colors = ### get color data
      img  = vision.image url
      img.properties.colors.each do |color|
        k.colors.create(rgb: color.rgb, red: color.red, green: color.green, blue: color.blue, 
          alpha: color.alpha, score: color.score, pixel_fraction: color.pixel_fraction)
      end
      counter += 1
      
    end
    puts "Success! You've gotten the color profile of each image of #{klass}"
  end

  desc "Import card_backgrounds"
  task card_backgrounds: :environment do
    require 'net/http'
    # array to catch the exceptions 
    errorArray = Array.new
    total_pages = import_page_json(Background, "https://www.paperlesspost.com/api/v1/card_backgrounds.json")

    2.upto(total_pages) do |page_num|
      # print progress
      puts "Importing page #{page_num}"
      begin
        import_page_json(Background, "https://www.paperlesspost.com/api/v1/card_backgrounds.json", page_num)
      rescue JSON::ParserError
        errorArray.push(page_num)
        puts "There was a JSON Parser Error !!! and page #{page_num} could not be imported :("
      end
    end

    puts "Import complete! The following pages could not be imported #{errorArray}"
  end

  desc "Import cards"
  task cards: :environment do
    require 'net/http'
    # array to catch the exceptions 
    errorArray = Array.new
    total_pages = import_page_json(Card, 'https://www.paperlesspost.com/api/v1/new_papers.json')
    puts "The total page number is #{total_pages}"
    puts "Importing page 1"

    # skipepd page 332
    # skipped page 418

    2.upto(total_pages) do |page_num|
      # print progress
      puts "Importing page #{page_num}"
      begin 
        import_page_json(Card, 'https://www.paperlesspost.com/api/v1/new_papers.json', page_num)
      rescue JSON::ParserError
        errorArray.push(page_num)
        puts "There was a JSON Parser Error !!! and page #{page_num} could not be imported :("
      end
    end
    puts "Import complete! The following pages could not be imported #{errorArray}"
  end


  desc "Import colors"
  task colors: :environment do
    import_color_profile(Background)
    import_color_profile(Card)
  end


end











