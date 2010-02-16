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
  
    it "reads element attribute values" do
      jquery("input[value='text']:first").val.should == "text"
    end
  
    it "sets text input values" do
      jquery("#text").val("new value")
      jquery("#text").attr('value').should == "new value"
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
  
    it "filters elements not matching selector" do
      jquery("input").not("#text").length.should ==  jquery("input").length - 1
    end
  
    it "selects elements by index" do
      jquery("input").eq(0).attr('name').should == jquery("input").first.attr('name')
    end
  
    it "detects elements having class names" do
      jquery("a.link").has_class("link").should be_true
      jquery("a").has_class("unlikely").should be_false
      jquery("a.unlikely").has_class("unlikely").should be_false
    end
  
    it "detects if any element matches selector" do
      jquery("a").is(".link").should be_true
      jquery("a:last").is(".link").should be_false
      jquery("a").is("z").should be_false
    end
  
    it "maps wrapped sets" do
      jquery("input").map { |a| a.attr('type') }.first.should == "text"
    end
  
    it "selects a subset of the matched elements" do
      three_links = jquery("#link1, #link2, #link3")
      three_links.slice(0, 2).map { |a| a.text }.should == ["link 1", "link 2"]
      three_links.slice(1).map { |a| a.text }.should == ["link 2", "link 3"]
    end
  
  end
end