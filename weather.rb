#!/apollo/env/SDETools/bin/ruby
require "shellwords"

LOCATIONS = [
  'North Cascades National Park',
  'Olympic National Park',
  'Mount Rainier National Park'
].freeze

DAYS_AND_INDEXES = {
  "Saturday" => [1,2],
  "Sunday" => [2,3]
}

URL = "http://wttr.in/"

current_most_sunny = 0
current_best_location = ""
current_best_day_index = nil

LOCATIONS.each do |location|
  puts location
  DAYS_AND_INDEXES.each do |day, (day_one, day_two)|
    url1 = "#{URL}~#{location.gsub(" ", "+")}?#{day_one}"
    url2 = "#{URL}~#{location.gsub(" ", "+")}?#{day_two}"

    weather =  `bash -c #{Shellwords.escape("diff <(curl -s '#{url1} 2>/dev/null') <(curl -s '#{url2}' 2>/dev/null)")}`
    puts weather
    sunny_or_clear = weather.scan(/Sunny|Clear/).count

    puts sunny_or_clear
    if sunny_or_clear.to_i > current_most_sunny
      current_most_sunny = sunny_or_clear.to_i
      current_best_location = location
      current_best_day_index = day_one
    end
  end
end

puts "The best day is #{current_best_location}, #{current_best_day_index} with #{current_most_sunny}"
