require File.join(File.dirname(__FILE__), "spec_helper")

fixture_url = "file://" + File.expand_path(File.join(File.dirname(__FILE__), "fixture.html")).gsub("\\", "/")

shared_examples_for "a browser" do
  include RQuery::BrowserDsl

  before(:each) do
    unless url == fixture_url
      visit fixture_url
    end
  end
  
  describe "Browser" do
    it "gets the title of the current document" do
      title.should include("Fixture")
    end
  
    it "gets the html of the current document" do
      html.should include("<html")
    end
  end
  
  describe "Core:" do
    
    describe "Object Accessors:" do
      
      describe "each(callback)" do
        it "executes a block within the context of every matched element." do
          elements = []
          jquery("a").each do |a|
            elements << a
          end
          elements.size.should == jquery("a").length
          elements.first.tag_name.downcase.should == "a"
        end
      end
      
      describe "size()" do
        it "returns the number of elements in the wrapped set." do
          jquery("input[type='button']").size.should == 2
        end
      end
      
      describe "length" do
        it "returns the number of elements in the wrapped set." do
          jquery("input[type='button']").length.should == 2
        end
      end
      
      describe "selector" do
        it "returns the selector originally passed to create the wrapped set" do
          jquery("input[type='button']").selector.should == "input[type='button']"
        end
      end
      
      describe "get()" do
        it "accesses all matched DOM elements as an array." do
          jquery("#link1, #link3").get.should be_a(Array)
          jquery("#link1, html").get[0].tag_name.downcase.should == "html"
        end
      end
      
      describe "get(index)" do
        it "accesses a single matched DOM element at a specified index in the matched set." do
          jquery("#link1, #link3").get(1).attr('id').should == "link3"
          jquery("#link1, html").get(0).tag_name.downcase.should == "html"
        end
      end
      
      describe "index(subject)" do
        it "Searches every matched element for the object and returns the index of the wrapped set, if " +
           "found, starting with zero." do
          jquery("#link1, #link2").index(jquery("#link2")).should == 1
          jquery("#link2").index("#link1, #link2").should == 1
          jquery("form > *:eq(1)").index.should == 1
        end
      end
      
    end
    
  end
  
  describe "Traversing:" do
    
    describe "Filtering:" do
    
      describe "eq(index)" do
        it "reduces the set of matched elements to a single element" do
          jquery("input").eq(0).attr('name').should == jquery("input").first.attr('name')
        end
      end
    
      describe "filter(expr)" do
        it "keeps only the elements from the set of matched elements that match the specified expression(s)." do
          submits = jquery("input").filter("[type='submit']")
          submits.length.should == 1
        end
      end
    
      describe "filter(fn)" do
        it "keeps only the elements from the set of matched elements where the specified block returns a non-false value." do
          submits = jquery("input").filter { |input| input.attr('type') == "submit" }
          submits.length.should == 1
        end
      end
      
      describe "has(expr)" do
        it "reduces the set of matched elements to those that have a descendant that matches the selector or wrapped set." do
          jquery("html").has("body").length.should == 1
          jquery("body").has("html").length.should == 0
          jquery("html").has(jquery("body")).length.should == 1
          jquery("html").has(jquery("html")).length.should == 0
        end
      end
    
      describe "is(expr)" do
        it "checks the current selection against an expression and returns true, if at least one element of the " +
           "selection fits the given expression." do
          jquery("a").is(".link").should be_true
          jquery("a:last").is(".link").should be_false
          jquery("a").is("z").should be_false
        end
      end
    
      describe "map(callback)" do
        it "translates a set of elements in the wrapped set into an array" do
          jquery("a:first, body").map { |a| a.tag_name.downcase }.should == ["body", "a"]
        end
      end
    
      describe "not(expr)" do
        it "removes elements matching the specified expression from the set of matched elements." do
          jquery("input").not("#text").length.should ==  jquery("input").length - 1
        end        
      end
    
      describe "slice(start, end)" do
        it "selects a subset of the matched elements." do
          three_links = jquery("#link1, #link2, #link3")
          three_links.slice(0, 2).map_text.should == ["link 1", "link 2"]
          three_links.slice(1).map_text.should == ["link 2", "link 3"]
        end
      end
    
    end

    describe "Finding:" do
    
      describe "add(expr)" do
        it "adds more elements, matched by the given expression, to the set of matched elements." do
          jquery("#link1, #link2, #link3").add("#text, #button1").length.should == 5
        end
      end
    
      describe "children(expr)" do
        it "gets a set of elements containing all of the unique immediate children of each of " +
           "the matched set of elements." do
          jquery("form").children.length.should == jquery("form > *").length
          jquery("form").children("input").length.should == jquery("form > input").length
        end
      end
    
      describe "closest(expr)" do
        it "gets a set of elements containing the closest ancestor element that matches the " +
           "specified selector, the starting element included." do
          jquery("#link1").closest("body, head, html").first.tag_name.downcase.should == "body"
          jquery("#link1").closest("h1").should be_empty
        end      
      end
    
      describe "contents()" do
        it "Find all the child nodes inside the matched elements (including text nodes), or the content document, if the element is an iframe." do
          pending
        end
      end
    
      describe "find(expr)" do
        it "searches for descendent elements that match the specified expression." do
          jquery("html").find("body").find("input").length.should == jquery("form > input").length
        end
      end
    
      describe "next(expr)" do
        it "gets a set of elements containing the unique next siblings of each of the given set of elements." do
          jquery("#link1").next("a").text.should == "link 2"
        end
      end
    
      describe "next_all(expr)" do
        it "finds all sibling elements after the current element." do
          jquery("#link1").next_all("#link2, #link3").map_text.should == ["link 2", "link 3"]
        end      
      end
      
      describe "next_until(expr)" do
        it "gets all following siblings of each element up to but not including the element " +
           "matched by the selector." do
          jquery("#link1").next_until("#link3").map_text.should == ["link 2"]
        end        
      end
    
      describe "offset_parent()" do
        it "returns a wrapped set with the positioned parent of the first matched element." do
          pending
        end
      end
    
      describe "parent(expr)" do
        it "gets the direct parent of an element. If called on a set of elements, parent returns a set of " +
            "their unique direct parent elements." do
          jquery("#link1").parent.is("body").should be_true
          jquery("#link1").parent("body").is("body").should be_true
        end      
      end
    
      describe "parents(expr)" do
        it "gets a set of elements containing the unique ancestors of the matched set of elements " +
           "(except for the root element)." do
             jquery("#link1").parents.length.should == 2
             jquery("#link1").parents("body").length.should == 1           
        end      
      end
    
      describe "prev(expr)" do
        it "gets a set of elements containing the unique previous siblings of each of the " +
           "matched set of elements." do
          jquery("#link2").prev("a").text.should == "link 1"
        end      
      end
    
      describe "prev_all(expr)" do
        it "finds all sibling elements in front of the current element." do
          jquery("#link3").prev_all("#link2, #link1").map_text.should == ["link 2", "link 1"]
        end      
      end
      
      describe "prev_until(expr)" do
        it "gets all preceding siblings of each element up to but not including the element matched by the selector." do
          jquery("#link3").prev_until("#link1").map_text.should == ["link 2"]
        end      
      end
    
      describe "siblings(expr)" do
        it "gets a set of elements containing all of the unique siblings of each of the matched set of elements." do
          jquery("#link2").siblings("#link1, #link3").map_text.should == ["link 1", "link 3"]
          jquery("#link2").siblings.filter("#link1, #link3").map_text.should == ["link 1", "link 3"]
        end      
      end
    
    end
  
    describe "Chaining:" do
    
      describe "and_self()" do
        it "adds the previous selection to the current selection." do
          pending
        end
      end
    
      describe "revert() (known as 'end' in jquery)" do
        it "reverts the most recent 'destructive' operation, changing the set of matched elements to its previous " +
           "state (right before the destructive operation)." do
          pending
        end
      end
    end
  
  end
  
  describe "Attributes:" do
    
    describe "attr(name)" do
      it "accesses a property on the first matched element." do
        jquery("input[value='text']:first").attr('value').should == "text"
        jquery("#link1, #link2, #link3").attr('id').should == "link1"
      end
    end
    
    describe "has_class(class)" do
      it "returns true if the specified class is present on at least one of the set of matched elements." do
        jquery("a.link").has_class("link").should be_true
        jquery("a").has_class("link").should be_true
        jquery("a").has_class("unlikely").should be_false
        jquery("a.unlikely").has_class("unlikely").should be_false
      end
    end
    
    describe "html()" do
      it "gets the html contents (innerHTML) of the first matched element." do
        jquery(".link").html.should == "link 1"
        jquery("html").html.downcase.should include("<body")
      end
    end
    
    describe "text()" do
      it "gets the combined text contents of all matched elements." do
        jquery("#link1").text.should == "link 1"
        jquery("#link1, #link2").text.should == "link 1link 2"
      end
    end
    
    describe "val()" do
      it "gets the input value of the first matched element." do
        jquery("#text").val.should == "text"
        jquery("input[type='text']").val.should == "text"
      end
    end

  end
  
  describe "CSS:" do
    describe "css(name)" do
      it "return a style property on the first matched element." do
        jquery("#link1, #link2").css("color").should == "red"
      end      
    end
  end
  
  describe "Events:" do
    describe "click" do
      it "clicks buttons" do
        jquery("#button1").click
        jquery("#button1, #button2").click
        jquery("#button2").click
        jquery("#log li").map_text.should == ["button 1 clicked",
                                              "button 1 clicked",
                                              "button 2 clicked",
                                              "button 2 clicked"] 
      end
      
      it "sets checkboxes" do
        jquery("#check1:checked, #check2:not(:checked)").should_not exist
        jquery("#check1, #check2").click
        jquery("#check1:checked, #check2:not(:checked)").length.should == 2
        jquery("#log li").map_text.should == ["check 1 changed", "check 2 changed"]
      end
    end
  end
  
  describe "Manipulation:" do
    describe "val(value)" do
      it "set the value of each element in the set of matched elements." do
        jquery("#text").val("new value")
        jquery("#text").attr('value').should == "new value"
        jquery("input[type='text']").val("even newer value")
        jquery("input[type='text']").attr('value').should == "even newer value"
      end      
    end
  end

end

describe "FireFox" do
  it_should_behave_like "a browser"

  before(:all) do
    RQuery::BrowserDsl.adapter = :firefox
  end
end

describe "Chrome" do
  it_should_behave_like "a browser"
  
  before(:all) do
    RQuery::BrowserDsl.adapter = :chrome
  end
end

if RUBY_PLATFORM.match(/win32|mingw32/)
  describe "Internet Explorer" do
    it_should_behave_like "a browser"
  
    before(:all) do
      RQuery::BrowserDsl.adapter = :ie
    end
  end
end