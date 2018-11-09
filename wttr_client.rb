require "shellwords"

class WttrClient
  WTTR_BASE_URL = "http://wttr.in/"

  CANADIANS = [
    'jlins',
    'lucalvin',
    'markkwok',
    'poguel'
  ].freeze

  def canadian?
    CANADIANS.include? `whoami`.strip
  end

  def weather_for(location, number_of_days_from_today)
    url1 = wttr_url_for(location, number_of_days_from_today)
    url2 = wttr_url_for(location, number_of_days_from_today + 1)

    weather =  `bash -c #{escaped_curl_and_diff_command(url1, url2)}`
  end

  private

  def wttr_url_for(location, number_of_days_from_today)
    url = "#{WTTR_BASE_URL}~#{location.gsub(" ", "+")}?#{number_of_days_from_today}"
    url += "m" if canadian?
    url
  end

  def escaped_curl_and_diff_command(url1, url2)
    Shellwords.escape(
      "diff <(curl -s '#{url1}' 2>/dev/null) <(curl -s '#{url2}' 2>/dev/null)"
    )
  end
end
