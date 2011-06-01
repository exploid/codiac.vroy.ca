require "app"

def read_schedule_page(url)
  doc = Nokogiri::HTML( open(url) )
  body = doc.css("#extrawidewhite")
  
  #route_name = body.at_css("h2:first").text
  gmaps = body.at_css("iframe").to_s
  
  #TODO: Think about saving the src attribute of the iframe only, and writing my own iframe in map.xhtml for resizing.
  
  schedule = ""
  first_h2 = nil
  body.children.each do |item|
    next if item.name == "iframe" # Saved gmaps iframe separately
    
    if item.name == "h2" and first_h2.nil? # Saved route name separately, we don't want to show it again in the body
      first_h2 = item.to_s
      next
    end
    
    schedule << item.to_s
  end
  
  return schedule, gmaps
end

doc = Nokogiri::HTML( open(SchedulesWebsite) )

doc.css("ul#sectionMenuElementID_0 ul:first li a").each do |link|
  puts link
  path = link.attributes["href"].to_s
  
  # Skip non-schedule pages caught by the css selector. I thought they would be skipped because of the ul:first
  next if !path.match(/\/Schedules\//)
  
  begin
    url = "#{SchedulesWebsiteBase}#{path}"
    
    schedule, gmaps = read_schedule_page(url)
    
    route_hash = { :name => link.text, :schedule => schedule, :gmaps => gmaps, :origin_url => url, :time_inserted => Time.now }
    
    route = Model::Route[:origin_url => url]
    if route
      route.update(route_hash)
    else
      Model::Route.create(route_hash)
    end
    
  rescue Exception => e
    puts "Failed for #{link} (#{url}) => #{e}"
  end
end
