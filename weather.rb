#!/usr/local/bin/ruby

require "date"
require_relative "wttr_client"

class WeatherGirl
  DEFAULT_LOCATIONS = [
    'North Cascades National Park',
    'Olympic National Park',
    'Mount Rainier National Park'
  ].freeze


  DAYS_OF_WEEK = %w(
    Sunday Monday Tuesday Wednesday Thursday Friday Saturday
  ).freeze

  def initialize
    @current_max_sunny_instances = 0
    @current_best_locations_and_day_indices = Hash.new []
  end

  def tell_me_where_to_go!
    locations.each do |location|
      [1,2].each do |day_index|
        print_weather_and_check_max_sunny_instances(location, day_index)
      end
    end

    print_results
  end

  def print_weather_and_check_max_sunny_instances(location, day_index)
    print_separator
    puts "#{location}: #{day_index_to_day_of_week(day_index)}"
    weather = WttrClient.new.weather_for(location, day_index)
    puts weather
    number_of_sunny_or_clear_instances = weather.scan(/Sunny|Clear/).count

    puts "Number of sunny or clear instances: #{number_of_sunny_or_clear_instances}"
    if new_maximum?(number_of_sunny_or_clear_instances)
      add_to_best_locations_and_update_max(number_of_sunny_or_clear_instances, location, day_index)
    end
  end

  def new_maximum?(number_of_sunny_or_clear_instances)
    number_of_sunny_or_clear_instances >= @current_max_sunny_instances
  end

  def add_to_best_locations_and_update_max(new_max, location, day_index)
    if new_max > @current_max_sunny_instances
      @current_max_sunny_instances = new_max
      @current_best_locations_and_day_indices.clear
    end
    @current_best_locations_and_day_indices[location] += [day_index]
  end

  def print_results
    print_separator
    puts "The following have the most sunny/clear instances with #{@current_max_sunny_instances}:"

    @current_best_locations_and_day_indices.each do |location, indices|
      indices.each do |day_index|
        puts "#{location}, #{day_index_to_day_of_week(day_index)}"
      end
    end
  end

  def remo?
    `whoami` == "remo"
  end

  def locations
    return ['Snoqualmie National Forest'] if remo?
    DEFAULT_LOCATIONS
  end

  def day_index_to_day_of_week(day_index)
    day_as_date = Date.today.next_day(day_index)
    day_of_week = DAYS_OF_WEEK[day_as_date.wday]
  end

  def print_separator
    puts "-" * 30
  end
end


WeatherGirl.new.tell_me_where_to_go!
