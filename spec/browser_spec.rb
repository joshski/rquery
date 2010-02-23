require File.join(File.dirname(__FILE__), "spec_helper")

module RQuery
  describe Browser do
    include BrowserDsl

    before(:all) do
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
      jquery("a").text.should include("link 1")
      jquery("a").text.should include("link 2")
      jquery("a#link1").text.should include("link 1")
    end
  
    it "reads element attribute values" do
      jquery("input[value='text']:first").val.should == "text"
    end
  
    it "sets text input values" do
      jquery("#text").val("new value")
      jquery("#text").attr('value').should == "new value"
    end
  
    it "clicks buttons" do
      jquery("#button1").click
      jquery("#button1, #button2").click
      jquery("#button2").click
      jquery("#log li").map_text.should == ["button 1 clicked",
                                            "button 1 clicked",
                                            "button 2 clicked",
                                            "button 2 clicked"] 
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
      three_links.slice(0, 2).map_text.should == ["link 1", "link 2"]
      three_links.slice(1).map_text.should == ["link 2", "link 3"]
    end
    
    it "adds selectors to the set of matched elements" do
      jquery("#link1, #link2, #link3").add("#text, #button1").length.should == 5
    end

    it "finds descendant elements" do
      jquery("html").find("body").find("input").length.should == jquery("form > input").length
    end
    
    it "finds elements that have descendant elements matching a selector" do
      jquery("html").has("body").length.should == 1
      jquery("body").has("html").length.should == 0
    end
    
    it "finds child elements" do
      jquery("form").children.length.should == jquery("form > *").length
      jquery("form").children("input").length.should == jquery("form > input").length
    end
    
    it "finds parent elements" do
      jquery("#link1").parent.is("body").should be_true
      jquery("#link1").parent("body").is("body").should be_true
    end
    
    it "finds ancestor elements" do
      jquery("#link1").parents.length.should == 2
      jquery("#link1").parents("body").length.should == 1
    end
    
    it "finds next sibling element matching selector" do
      jquery("#link1").next("a").text.should == "link 2"
    end
    
    it "finds all next sibling elements matching selector" do
      jquery("#link1").next_all("#link2, #link3").map_text.should == ["link 2", "link 3"]
    end
    
    it "finds all next sibling elements until selector matches" do
      jquery("#link1").next_until("#link3").map_text.should == ["link 2"]
    end

    it "finds previous sibling element matching selector" do
      jquery("#link2").prev("a").text.should == "link 1"
    end
    
    it "finds all previous sibling elements matching selector" do
      jquery("#link3").prev_all("#link2, #link1").map_text.should == ["link 2", "link 1"]
    end
    
    it "finds all previous sibling elements until selector matches" do
      jquery("#link3").prev_until("#link1").map_text.should == ["link 2"]
    end
    
    it "finds siblings" do
      jquery("#link2").siblings("#link1, #link3").map_text.should == ["link 1", "link 3"]
      jquery("#link2").siblings.filter("#link1, #link3").map_text.should == ["link 1", "link 3"]
    end
    
    it "finds the closes element progressing up through the DOM tree" do
      jquery("#link1").closest("body, head, html").first.tag_name.downcase.should == "body"
      jquery("#link1").closest("h1").should be_empty
    end
    
    it "gets the value of style properties" do
      jquery("body").css("font-family").should == "sans-serif"
    end
  
  end
end