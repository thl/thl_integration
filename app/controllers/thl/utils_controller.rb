class Thl::UtilsController < ApplicationController
  
  def proxy
    
    # We want to grab params that are part of the requested URL, but ignore ones that are supplied by Rails
    ignored_params = ["proxy_url", "action", "controller"]
    url_params = params.reject{|param, val| ignored_params.include?(param) }.collect{ |param, val| param + '=' + CGI.escape(val) }.join('&')
    
    url = params[:proxy_url]
    url += '&' + url_params unless url_params.blank?
    url = "http://www.thlib.org" + url if url[0,1] == "/"
    
    # Any "&"s in the url sent to wiki_reader.php need to be replaced by "%26"
    if url =~ /wiki_reader\.php\?url=/
      url_split = url.split("wiki_reader.php?url=")
      url_split[1].gsub!("&", "%26")
      url = url_split.join("wiki_reader.php?url=")
    end
    
    # Parse the URL with URI.parse() so we can work with its parts more easily
    uri = URI.parse(URI.encode(url));
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
    
    path = uri.query.blank? ? uri.path : uri.path + '?' + uri.query 
    request = Net::HTTP::Get.new(path, headers)
    result = Net::HTTP.start(uri.host, uri.port) {|http|
      http.request(request)
    }
    
    render :text => result.body
    
  end
  
end