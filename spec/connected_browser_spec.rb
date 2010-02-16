require File.join(File.dirname(__FILE__), "spec_helper")

module RQuery
  describe Browser, "connected to the web" do
    include BrowserDsl

    after(:all) do
      close
    end
    
    it "finds jquery documentation" do
      visit "http://www.google.com"
      title.should include("Google")
      html.should include("Google")
      jquery("input[name='q']").val("jquery")
      jquery("input[name='q']").val.should == "jquery"
      jquery("input[value='Google Search']").click
      first_result = jquery("a:contains('jQuery'):first")
      first_result.text.should include("Write Less, Do More")
      first_result.click
      title.should include("Write Less, Do More")
      jquery("a:contains('Documentation')").click
      jquery("h1.firstHeading").text.should == "Main Page"
      jquery("img:first").attr("src").should =~ /jquery/
      jquery("img").eq(0).attr("src").should =~ /jquery/
      jquery("#jq-primarySearch").val("selectors")
      jquery("#jq-searchGoButton").click
      jquery("a:contains('Attribute Ends With')").length.should == 1
    end
  end
end
