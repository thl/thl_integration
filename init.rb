# Include hook code here
require 'open-uri'
# Using hpricot. require 'hpricot' no longer needed as this is done automatically by rails 3 in Gemfile.
require 'thdl_integration'
ActionView::Base.send :include, ThdlIntegrationHelper
ActionView::Base.send :include, FrameHelper
ActionView::Base.send :include, TinyMceExtensionHelper