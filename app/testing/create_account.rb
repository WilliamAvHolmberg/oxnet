require 'net/http'
require 'uri'
require 'json'

uri = URI.parse("https://secure.runescape.com/m=account-creation/create_account")

header = {'Content-Type': 'text/json',
          'Host': "secure.runescape.com",
          'User-Agent': "Mozilla/5.0 (Windows NT x.y; rv:10.0) Gecko/20100101 Firefox/10.0",
          'Accept': "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
          'Accept-Language': "en-US,en);q=0.5",
          'Accept-Encoding': "gzip, deflate, br",
          'Referer': "http://oldschool.runescape.com/"
}

body = {
    'email1': "myemailasd@gmail.com",
    'onlyOneEmail': "1",
'password1': "ugot00wned2",
params.add(new BasicNameValuePair("onlyOnePassword", "1"));
params.add(new BasicNameValuePair("day", "1"));
params.add(new BasicNameValuePair("month", "2"));
params.add(new BasicNameValuePair("year", "1999"));
params.add(new BasicNameValuePair("g-recaptcha-response", gResponse));
params.add(new BasicNameValuePair("submit", "Play Now"));
}



# Create the HTTP objects
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.request_uri, header)
#request.body = user.to_json

# Send the request
response = http.request(request)
puts response