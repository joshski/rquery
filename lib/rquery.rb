require 'forwardable'

$:.unshift(File.dirname(__FILE__))

require 'rquery/wrapped_set'
require 'rquery/selenium_adapter'
require 'rquery/watir_adapter'
require 'rquery/browser'
require 'rquery/browser_dsl'