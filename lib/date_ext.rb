
class DateTime
  # Returns a new DateTime representing the time a number of seconds ago
  # Do not use this method in combination with x.months, use months_ago instead!
  def seconds_ago(seconds)
    since(-seconds)
  end

  def minutes_ago(minutes)
    seconds_ago(-(minutes*60))
  end

  def hours_ago(hours)
    minutes_ago(-(hours*60))
  end

  # Returns a new DateTime representing the time a number of seconds since the instance time
  # Do not use this method in combination with x.months, use months_since instead!
  def since(seconds)
    self + Rational(seconds.round, 86400)
  end
end
