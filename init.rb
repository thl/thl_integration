# Include hook code here
require 'open-uri'
require 'hpricot'
require 'patches/traverse'
require 'thdl_integration'
ActionView::Base.send :include, ThdlIntegrationHelper
ActionView::Base.send :include, FrameHelper