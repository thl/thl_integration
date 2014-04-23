module ThlIntegrationHelper
  def google_maps_key
    'AIzaSyB7IlhcOYVWmvJOPZDYWCBAc4ZXDlH7r6Q'
    # InterfaceUtils::Server.environment == InterfaceUtils::Server::EBHUTAN ? 'ABQIAAAA-y3Dt_UxbO4KSyjAYViOChQYlycRhKSCRlUWwdm5YkcOv9JZvxQ7K1N-weCz0Vvcplc8v8TOVZ4lEQ'
  end
  
  def primary_tabs_list
    [
      {
        :id => :places,
        :title => "Places",
        :app => :places,
        :url => defined?(PlacesIntegration::PlacesResource.get_url) ? PlacesIntegration::PlacesResource.get_url : false
      },
      {
        :id => :topics,
        :title => defined?(SubjectsIntegration) ? SubjectsIntegration::Feature.human_name(:count => :many).titleize.s : (defined?(Feature) ? Feature.model_name.human(:count => :many).titleize.s : Category.human_name(:count => :many).titleize.s),
        :app => :topics,
        :url => defined?(SubjectsIntegration::SubjectsResource.get_url) ? SubjectsIntegration::SubjectsResource.get_url : false
      },
      {
        :id => :media,
        :title => defined?(MmsIntegration) ? MmsIntegration::Medium.human_name(:count => :many).titleize.s : Medium.model_name.human(:count => :many).titleize.s,
        :app => :media,
        :url => defined?(MediaManagementResource.get_url) ? MediaManagementResource.get_url : root_path
      },
      {
        :id => :dictionary,
        :title => "Tibetan",
        :app => :dictionary,
        :url => defined?(DictionarySite.get_url) ? DictionarySite.get_url : false
      },
      {
        :id => :himalayan_search,
        :title => "Himalayan",
        :app => :himalayan_search,
        :url => (defined?(MediaManagementResource.get_url) ? MediaManagementResource.get_url : root_path) + 'dictionary_searches/new'
      }
    ]
  end
  
  def header(body_attributes = Hash.new)
    frame_init()
    js_files = body_attributes.delete(:javascript_files)
    css_files = body_attributes.delete(:stylesheet_files)
    title = body_attributes.delete(:title) || "#{controller.controller_name.humanize}: #{controller.action_name.humanize}"
    attrs = attributes(:template => body_attributes.delete(:template))
    return (attrs[:html_start] +
           "<title>#{title}</title>\n" +
           "#{www_js}\n" +
           "#{javascript_include_tag(*(js_files.nil? ? javascript_files : javascript_files + js_files))}\n" +
           "#{frame_js}\n" +
           "#{stylesheet_link_tag(*(css_files.nil? ? stylesheet_files : stylesheet_files + css_files))}\n" +
           "#{frame_css}\n" +
           "#{csrf_meta_tags}\n" +
           ( in_frame? ? "<style type='text/css'>#TB_window { top: 25% !important }</style>\n" : "" ) +
           "</head>\n" +
           "<body #{body_attributes.collect{|at, value| "#{at.to_s}=\"#{value}\""}.join(' ')}>#{attrs[:body_start]}\n#{side_column}\n#{attrs[:post_side_column]}" + 
           "<div id=\"login-status\">" +
           "#{login_status}#{'&nbsp;'*3}" +
           language_option_links +
           "</div>\n#{attrs[:content_start]}\n#{flash_notice}").html_safe
  end

  def header_iframe(body_attributes = {:class => 'full-width'})
    frame_init()
    attrs = attributes(:iframe => true)
    return (attrs[:html_start] +
           "<title>#{controller.controller_name.humanize}: #{controller.action_name.humanize}</title>\n" +
           "#{javascript_include_tag javascript_files}\n" +
           "#{frame_js}\n" +
           "#{stylesheet_link_tag stylesheet_files}\n" +
           "#{stylesheet_link_tag('thl_integration/iframe')}\n" +
           "#{frame_css}\n" +
           "#{csrf_meta_tags}\n" +
           "</head>\n" +
           "<body id=\"body\" #{body_attributes.collect{|at, value| "#{at.to_s}=\"#{value}\""}.join(' ')}>#{attrs[:body_start]}\n" + 
           "\n#{attrs[:content_start]}\n#{flash_notice({:no_margin => true})}").html_safe
  end
    
  def footer
    return thdl_footer.html_safe
  end
  
  def stylesheet_files
    ['application']
  end
  
  def javascript_files
    ['application']
  end
  
  def loading_animation_script(selector)
    "$(\'#{selector}\').css(\'background\', \'url(#{InterfaceUtils::Server.get_url}/global/images/ajax-loader.gif) no-repeat center right\')".html_safe
  end

  def reset_animation_script(selector)
    "$(\'#{selector}\').css(\'background\', \'none\')".html_safe
  end
  
  private
  
  def attributes(options = Hash.new)
    cache_key = 'thl-layout-attributes'
    if options[:iframe]
      cache_key << '-iframe' 
    elsif in_frame?
      cache_key << '-in-frame'
    end
    Rails.cache.fetch(cache_key, :expires_in => 1.day) do
      attrs = {}
      if options[:iframe]
        doc = ThlIntegration.get_layout_document({:template => 'index-offsite-iframe'})
        head = doc/'head'
        head.search('title').remove
        head_html = head.to_html
        content = doc%'div#content'
        content.inner_html = ''
        html = doc.to_html
        head_end = html.index('</head>')    
        attrs[:html_start] = html[0...head_end]
        body_tag_start = html.index('<body')
        body_tag_end = html.index('>', body_tag_start)
        body_end = html.index('<!-- begin content -->')
        attrs[:body_start] = html[body_tag_end+1...body_end]
        content_html = content.to_html
        relative_content_end = content_html.index('</')
        content_start = html.index(content_html)
        attrs[:content_start] = html[content_start...content_start+relative_content_end]
        attrs[:footer] = html[content_start+relative_content_end...html.size]
      elsif !in_frame?
        doc = ThlIntegration.get_layout_document(:template => options[:template])
        head = doc/'head'
        head.search('title').remove
        head_html = head.to_html
        content = doc%'div#content'
        content.inner_html = ''
        html = doc.to_html
        head_end = html.index('</head>')
        attrs[:html_start] = html[0...head_end]
        body_tag_start = html.index('<body')
        body_tag_end = html.index('>', body_tag_start)
        side_column_start = html.index('<!-- begin side column -->')
        attrs[:body_start] = html[body_tag_end+1...side_column_start+26]
        side_column_object = doc%'div#side-column'
        (side_column_object/'div#list1').prepend("<div id=\"app-vertical-links\"></div>")
        attrs[:side_column] = side_column_object.to_html
        content_html = content.to_html
        relative_content_end = content_html.index('</')
        post_sidenav_start = html.index('<!-- end side column -->')
        post_sidenav_end = html.index('<!-- end masthead utility -->')
        content_start = html.index(content_html)
        attrs[:post_side_column] = html[post_sidenav_start...post_sidenav_end]
        attrs[:content_start] = html[post_sidenav_end...content_start+relative_content_end]
        attrs[:footer] = html[content_start+relative_content_end...html.size]
      else
        attrs[:html_start] = "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"
          \"http://www.w3.org/TR/html4/strict.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\"><head>"
        attrs[:content_start] = "<div id=\"body-wrapper\" style=\"width:#{frame_width}; background-image: none\"><div id=\"content\" style=\"background-image: none;\"><div class=\"shell-1\">"
        attrs[:footer] = "</div></div></div></div><script type=\"text/javascript\" language=\"Javascript\">var bookmark_url = '#{frame_bookmark}' ; $(document).ready(function(){ frame_service.init() });</script>\n</body></html>"
        attrs[:body_start] = ''
        attrs[:post_side_column] = ''
      end
      attrs
    end
  end  
      
  def content_end
    attributes[:content_end]
  end
  
  def side_column
    if !in_frame?
      # ($side_column_object%'div#login-status').inner_html = login_status
      side_column_object = Hpricot(attributes[:side_column])
      (side_column_object%'div#app-vertical-links').inner_html = side_column_links
      side_column_object.to_html
    end
  end
  
  def thdl_footer
    return attributes[:footer]
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