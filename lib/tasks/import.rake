namespace :import do

  def import_page_json(type, url, page_num = 1)
    source = "#{url}?page=#{page_num}"
    resp = Net::HTTP.get_response(URI.parse(source))
    data = resp.body
    result = JSON.parse(data)
    images = result[type]

    images.each do |img|
      Image.create(url: img["image_url"], pp_id: img["id"])
    end

    result["total_pages"]
  end

  desc "Import card_backgrounds"
  task card_backgrounds: :environment do
    require 'net/http'
    
    total_pages = import_page_json("card_backgrounds", "https://www.paperlesspost.com/api/v1/card_backgrounds.json")

    2.upto(total_pages) do |page_num|
      puts "Importing page #{page_num}"
      import_page_json("card_backgrounds", "https://www.paperlesspost.com/api/v1/card_backgrounds.json", page_num)
    end

  end

  desc "Import cards"
  task cards: :environment do
    require 'net/http'
    
    total_pages = import_page_json('records', 'https://www.paperlesspost.com/api/v1/new_papers.json')
    puts "The total page number is #{total_pages}"
    puts "Importing page 1"
    2.upto(total_pages) do |page_num|
      puts "Importing page #{page_num}"
      import_page_json('records', 'https://www.paperlesspost.com/api/v1/new_papers.json', page_num)
    end

  end

end
