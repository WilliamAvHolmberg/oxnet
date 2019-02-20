def formatted_duration(total_seconds)
  dhms = [60, 60, 24].reduce([total_seconds]) { |m,o| m.unshift(m.shift.divmod(o)).flatten }

  return "%ddays %dhrs" % dhms unless dhms[0].zero?
  return "%dhrs %dmins" % dhms[1..3] unless dhms[1].zero?
  return "%dmins" % dhms[2..3] unless dhms[2].zero?
  "%dsecs" % dhms[3]
end

module Pinger
  @pingHistory = {""=> false}
  @pingHistoryTimeStamps = {""=> Time.now}
  def self.ProxyAvailable(ip, port)
    return true if ip.length == 0
    key = ip + ":" + port
    working = @pingHistory[key]
    lastChecked = @pingHistoryTimeStamps[key]
    if(working == nil || lastChecked == nil || (Time.now - lastChecked) > 120)
      respond = Net::Ping::TCP.new(ip, port).ping
      working = (respond != nil && respond != false && respond > 0)
      @pingHistory[key] = working
      @pingHistoryTimeStamps[key] = Time.now
      if working
        puts "Proxy #{ip} is working"
      else
        puts "Proxy #{ip} failed"
      end
    end
    return working
  end
end