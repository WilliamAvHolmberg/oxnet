

def formatted_duration(total_seconds)
  return "" if total_seconds == nil
  dhms = [60, 60, 24].reduce([total_seconds]) { |m,o| m.unshift(m.shift.divmod(o)).flatten }

  return "%ddays %dhrs" % dhms unless dhms[0].zero?
  return "%dhrs %dmins" % dhms[1..3] unless dhms[1].zero?
  return "%dmins" % dhms[2..3] unless dhms[2].zero?
  "%dsecs" % dhms[3]
end

def formatted_gp(gp)
  if(gp > 1000000)
    return (gp / 1000000.0).round(1).to_s + "M gp"
  elsif(gp > 1000)
    return (gp / 1000.0).round(1).to_s + "K gp"
  else
    return gp.to_s + "gp"
  end
end



module Pinger
  @pingHistory = {""=> false}
  @pingHistoryTimeStamps = {""=> Time.now}
  def self.ProxyAvailable(proxy)
    return true if proxy == nil
    ip = proxy.ip
    port = proxy.port
    return true if ip == nil || ip.length == 0
    return true if port == nil || port.length == 0
    key = ip + ":" + port
    working = @pingHistory[key]
    lastChecked = @pingHistoryTimeStamps[key]
    if (lastChecked == nil || proxy.last_checked.localtime > lastChecked)
      lastChecked = proxy.last_checked.localtime
      working = proxy.available
    end
    if(working == nil || lastChecked == nil || (Time.now - lastChecked) > 10.minutes)
      respond = Net::Ping::TCP.new(ip, port).ping
      working = (respond != nil && respond != false && respond > 0)
      @pingHistory[key] = working
      @pingHistoryTimeStamps[key] = Time.now + rand(5..120).seconds
      proxy.update(last_checked: Time.now.utc + rand(5..120).seconds, available: working)
      if working
        puts "Proxy #{ip} is working"
      else
        puts "Proxy #{ip} failed"
      end
    end
    return working
  end
end