require File.join(File.dirname(__FILE__), "spec_helper")

module RQuery
  describe Browser do
    include BrowserDsl

    before(:each) do
      visit "file://" + File.join(File.dirname(__FILE__), "fixture.html").gsub("\\", "/")
    end

    after(:all) do
      close
    end
    
    it "has a title" do
      title.should include("Fixture")
    end
    
    it "has html" do
      html.should include("<html")
    end
  
    it "finds element text" do
      jquery("h1").text.should include("Fixture")
    end
    
    it "clicks buttons" do
      jquery("#button").click
      jquery("#log").text.should == "button clicked"
    end
    
    it "finds set length" do
      jquery("input").length.should > 1
    end
    
    it "finds sets of elements" do
      jquery("input").length.should > 1
    end
    
    it "filters by block" do
      submits = jquery("input").filter { |input| input.attr('type') == "submit" }
      submits.length.should == 1
    end
    
    it "filters by selector" do
      submits = jquery("input").filter("[type='submit']")
      submits.length.should == 1
    end
  end
end