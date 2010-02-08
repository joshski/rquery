require 'rubygems'
require 'spec'

require 'watir_adapter'
require 'watir_browser'
require 'wrapped_set'
require 'browser'
require 'forwardable'

module ForwardsToBrowser
  extend Spec::Example::BeforeAndAfterHooks
  extend Forwardable
  def_delegators :@browser, :visit, :jquery, :title
end

describe Browser do
  describe "with a WatirAdapter" do
    include ForwardsToBrowser
    
    before(:all) do
      @browser = Browser.new(WatirAdapter.new)
    end
    
    it "finds jquery documentation" do
      visit "http://www.jquery.com"
      title.should include("Write Less, Do More")
      jquery("a:contains('Documentation')").click
      jquery("h1.firstHeading").text.should == "Main Page"
      jquery("img:first").attr("src").should =~ /jquery/
      jquery("img").eq(0).attr("src").should =~ /jquery/
      jquery("#jq-primarySearch").val("selectors")
      jquery("#jq-searchGoButton").click
      jquery("a:contains('Attribute Ends With')").length.should == 1
    end
 
    it "searches google" do
      visit "http://www.google.com"
      title.should include("Google")
      jquery("input[name='q']").val("jquery")
      jquery("input[value='Google Search']").click
      jquery("a:contains('jQuery'):first").text.should include("Write Less, Do More")
    end
  end
end