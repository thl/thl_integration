module ThdlIntegrationHelper
  def header(body_attributes = Hash.new)
    frame_init()
    load_attributes if $html_start.blank?
    return $html_start +
           "<title>#{controller.controller_name.humanize}: #{controller.action_name.humanize}</title>\n" +
           "#{www_js}\n" +
           "#{javascripts}\n" +
           "#{frame_js}\n" +
           "\n#{stylesheets}\n" +
           "#{frame_css}\n" +
           "</head>\n" +
           "<body id=\"body\" #{body_attributes.collect{|at, value| "#{at.to_s}=\"#{value}\""}.join(' ')}>#{$body_start}\n#{side_column}\n#{$post_side_column}" + 
           "<div id=\"login-status\">" +
           "#{login_status}#{'&nbsp;'*3}" +
           language_option_links +
           "</div>\n#{$content_start}\n#{flash_notice}"
  end

  def header_iframe(body_attributes = {:class => 'full-width'})
    frame_init()
    load_attributes({:iframe => true}) if $html_start.blank?
    return $html_start +
           "<title>#{controller.controller_name.humanize}: #{controller.action_name.humanize}</title>\n" +
           "#{javascripts}\n" +
           "#{frame_js}\n" +
           "#{stylesheets}\n" +
           "#{stylesheet_link_tag('iframe')}\n" +
           "#{frame_css}\n" +
           "</head>\n" +
           "<body id=\"body\" #{body_attributes.collect{|at, value| "#{at.to_s}=\"#{value}\""}.join(' ')}>#{$body_start}\n" + 
           "\n#{$content_start}\n#{flash_notice({:no_margin => true})}"
  end
    
  def footer
    return thdl_footer
  end
  
  def stylesheet_files
    ['authenticated_system', 'base', 'language_support']
  end
  
  def javascript_files
    [:defaults]
  end
  
  def stylesheets
    return stylesheet_link_tag(*stylesheet_files)
  end
  
  def javascripts
    return javascript_include_tag(*javascript_files)
  end
  
  def loading_animation_script(id)
    "$(\'##{id}\').css(\'background\', \'url(http://www.thlib.org/global/images/ajax-loader.gif) no-repeat center right\')"
  end

  def reset_animation_script(id)
    # "$(\'##{id}\').css(\'background\', \'none\')"
    ''
  end
  
  private
  
  def load_attributes(options = Hash.new)
    if options[:iframe]
      doc = ThdlIntegration.get_layout_document({:template => 'index-offsite-iframe'})
      head = doc/'head'
      head.search('title').remove
      head.append("<meta name=\"MSSmartTagsPreventParsing\" content=\"TRUE\">\n")
      head_html = head.to_html
      content = doc%'div#content'
      content.inner_html = ''
      html = doc.to_html
      head_end = html.index('</head>')    
      $html_start = html[0...head_end]
      body_tag_start = html.index('<body')
      body_tag_end = html.index('>', body_tag_start)
      body_end = html.index('<!-- begin content -->')
      $body_start = html[body_tag_end+1...body_end]
      content_html = content.to_html
      relative_content_end = content_html.index('</')
      content_start = html.index(content_html)
      $content_start = html[content_start...content_start+relative_content_end]
      $footer = html[content_start+relative_content_end...html.size]
    elsif !in_frame()
      doc = ThdlIntegration.get_layout_document
      head = doc/'head'
      head.search('title').remove
      head.append("<meta name=\"MSSmartTagsPreventParsing\" content=\"TRUE\">\n")
      head_html = head.to_html
      content = doc%'div#content'
      content.inner_html = ''
      html = doc.to_html
      head_end = html.index('</head>')    
      $html_start = html[0...head_end]
      body_tag_start = html.index('<body')
      body_tag_end = html.index('>', body_tag_start)
      side_column_start = html.index('<!-- begin sliding side column -->')
      $body_start = html[body_tag_end+1...side_column_start]
      $side_column_object = doc%'div#side-column'
      ($side_column_object/'div#list1').prepend("<div id=\"app-vertical-links\"></div>")
      content_html = content.to_html
      relative_content_end = content_html.index('</')
      post_sidenav_start = html.index('<!-- Link for Side-Menu -->')
      side_column_links_pos = html.index('<!-- Advanced Search -->')
      content_start = html.index(content_html)
      $post_side_column = html[post_sidenav_start...side_column_links_pos]
      $content_start = html[side_column_links_pos...content_start+relative_content_end]
      $footer = html[content_start+relative_content_end...html.size]
    else
      $html_start = "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"
        \"http://www.w3.org/TR/html4/strict.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\"><head>"
      $content_start = "<div id=\"body-wrapper\" style=\"width:#{frame_width}; background-image: none\"><div id=\"content\" style=\"background-image: none;\"><div class=\"shell-1\">"
      $footer = "</div></div></div></div><script type=\"text/javascript\" language=\"Javascript\">var bookmark_url = '#{frame_bookmark}' ; $(document).ready(function(){ frame_service.init() });</script>\n</body></html>"
      $body_start = ''
      $post_side_column = ''
    end
  end  
  
  # this method relies on the authenticated_system plugin
  def login_status
    if !in_frame()
      if !logged_in?
        return "#{link_to 'Login', authenticated_system_login_path}."
      else
        return "#{current_user.login}. #{link_to 'Logout', authenticated_system_logout_path}."
      end
    else
      return ''
    end
  end
  
  # this method relies on the complex scripts plugin
  def language_option_links
    render(:partial => 'sessions/language_options')
  end
  
  def content_end
    load_attributes if $content_end.blank?
    return $content_end
  end
  
  def side_column
    if !in_frame()
      load_attributes if $side_column_object.nil?
      # ($side_column_object%'div#login-status').inner_html = login_status
      ($side_column_object%'div#app-vertical-links').inner_html = side_column_links
      $side_column_object.to_html
    end
  end
  
  def thdl_footer
    load_attributes if $footer.blank?
    return $footer
  end
  
  def flash_notice(options = Hash.new)
    return "<div class=\"shell-1\"" +
           (options[:no_margin] ? ' style="margin:0;"' : '') +
           "><div id=\"div_flash-notice\">\n" +
           "<p style=\"color: green;" +
           (options[:no_margin] ? ' margin:0;' : '') +
           "\">#{flash[:notice]}</p>\n" +
           "</div></div>" if !flash[:notice].blank?
  end
end