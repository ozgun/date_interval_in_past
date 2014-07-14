require 'minitest/autorun'

#require_relative "../date_interval"

class TestDateIntervalInPast < MiniTest::Unit::TestCase

  def test_end_date_should_be_bigger_than_end_date
    start_date, end_date = DateIntervalInPast.generate

    assert(end_date > start_date)
  end

  def test_start_date_and_end_date_should_be_dates_in_past
    start_date, end_date = DateIntervalInPast.generate

    assert(start_date < Time.now)
    assert(end_date < Time.now)
  end

  def test_generates_radom_dates_in_past
    start_date1, end_date1 = DateIntervalInPast.generate
    start_date2, end_date2 = DateIntervalInPast.generate

    assert(start_date1 != start_date2)
    assert(end_date1 != end_date2)
  end

  def test_start_and_end_dates_should_be_in_the_same_day
    start_date, end_date = DateIntervalInPast.generate

    assert(start_date.strftime("%Y-%m-%d") == end_date.strftime("%Y-%m-%d"))
  end

  def test_generates_dates_for_today_if_expilicitly_requested
    start_date, end_date = DateIntervalInPast.generate(true)

    assert(start_date.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d"))
    assert(end_date.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d"))
  end

end

class DateIntervalInPast

  def self.generate(today = false)
    start_date = generate_start_date(today)
    end_date = generate_end_date(start_date)
    #puts "#{start_date} --- #{end_date}"
    [start_date, end_date]
  end

  private

  def self.generate_start_date(today)
    if today
      diff = rand(current_hour_as_minutes)
    else
      n_minutes_back = rand(60 * 24 * 30) # Son 30 gün
      diff = rand(n_minutes_back) + 1
    end

    Time.at(Time.now.to_i - to_second(diff))
  end


  def self.generate_end_date(start_date)
    range1 = time_as_minutes(start_date)

    if today?(start_date)
      # Eğer bugün için bir tarih üretiliyorsa şimdiki zamandan ileri bir zaman olmamalı.
      range2 = time_as_minutes(Time.now)
    else
      # Eğer geçmişte bir gün için üretiliyorsa gün sonuna kadar herhangi bir zaman olabilir.
      range2 = minutes_past_until_midnight
    end

    diff = rand(range2 - range1)

    start_date + to_second(diff)
  end

  def self.to_second(minutes_from_start_of_day)
    60 * minutes_from_start_of_day
  end

  def self.current_hour
    Time.now.hour
  end

  def self.current_hour_as_minutes
    #current_time = Time.now
    #(current_time.hour * 60) + current_time.min
    time_as_minutes(Time.now)
  end

  # Gece yarısından itibaren geçen dakika.
  def self.time_as_minutes(time)
    (time.hour * 60) + time.min
  end

  def self.today?(time)
    time.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
  end

  def self.minutes_past_until_midnight
    24 * 60
  end

end
