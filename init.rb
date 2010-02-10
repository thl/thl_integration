# Include hook code here
require 'open-uri'
require 'hpricot'
require 'patches/traverse'
require 'patches/active_resource_patch'
require 'thdl_integration'
ActionView::Base.send :include, ThdlIntegrationHelper
ActionView::Base.send :include, FrameHelper