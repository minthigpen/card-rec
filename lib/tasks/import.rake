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
  task
  #     Background.all.each do |bg|
  #   url = bg.url
  #   set_colors = ### get color data
  #   set_colors.each do |color|
  #     bg.colors.create(red: color.red, green: color.green ....)
  #   end
  # end


end
