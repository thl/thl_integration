# Include hook code here
require 'open-uri'
require 'hpricot'
require 'thdl_integration'
ActionView::Base.send :include, ThdlIntegrationHelper
ActionView::Base.send :include, FrameHelper
ActionView::Base.send :include, TinyMceExtensionHelper

ActionController::Base.session = { :domain => ".thlib.org" }