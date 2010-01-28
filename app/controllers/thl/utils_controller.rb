class Thl::UtilsController < ApplicationController
  
  def proxy
    ignored_params = ["proxy_url", "action", "controller"]
    url_params = params.reject{|param, val| ignored_params.include?(param) }.collect{ |param, val| param + '=' + CGI.escape(val) }.join('&')
    url = params[:proxy_url].join('/') + '?' + url_params
    url = "http://www.thlib.org" + url if url[0,1] == "/"
    uri = URI.parse(url)
    requested_host = uri.host
    headers = {}
    # Check to see if the request is for a URL on thlib.org or a subdomain; if so, and if
    # this is being run on sds[3-8], make the appropriate changes to headers and uri.host
    if requested_host =~ /thlib.org/
      server_host = Socket.gethostname.downcase
      if server_host =~ /sds[3-8].itc.virginia.edu/
        headers = { 'Host' => requested_host }
        uri.host = '127.0.0.1'
      end
    end
    # Required for requests without paths (e.g. http://www.google.com)
    uri.path = "/" if uri.path.empty?
    request = Net::HTTP::Get.new(uri.path + '?' + uri.query, headers)
    result = Net::HTTP.start(uri.host, uri.port) {|http|
      http.request(request)
    }
    render :text => result.body
  end
  
end