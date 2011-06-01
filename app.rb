require "rubygems"

gem "ramaze", "2009.03"
require "ramaze"

require "github/markup"

require "nokogiri"
require "open-uri"
require "sequel"
require "pp"

DB = Sequel.connect("mysql://root:asdf@localhost/codiactranspo")

module Model
  class Route < Sequel::Model(:routes)
  end
end

SchedulesWebsite = "http://www.codiactranspo.ca/Schedules.htm"
SchedulesWebsiteBase = "http://www.codiactranspo.ca"

Ramaze.acquire("controller/*")

__END__

# The id will be the order they appear in the schedules page.
# This means that we'll have to update the records when we re-crawl
CREATE TABLE routes (
  id INTEGER PRIMARY KEY NOT NULL auto_increment,
  name VARCHAR(100) CHARACTER SET utf8,
  schedule TEXT,
  gmaps TEXT,
  origin_url VARCHAR(255) CHARACTER SET utf8 UNIQUE,
  time_inserted TIMESTAMP default CURRENT_TIMESTAMP
) DEFAULT CHARACTER SET = utf8;
