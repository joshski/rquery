module RQuery
  module WrappedSetMethods
    include Enumerable
    
    def length
      eval_jquery ".length"
    end
  
    def val(value=nil)
      if value.nil?
        eval_jquery ".val()"
      else
        exec_jquery %|.val("#{value}")|
      end
    end
  
    def text
      assert_exists
      eval_jquery ".text()"
    end
  
    def html
      eval_jquery ".html()"
    end
  
    def attr(key)
      eval_jquery ".attr(\"#{key}\")"
    end
  
    def click
      assert_exists
      eval_jquery("[0]").click
    end
  
    def find(selector)
      child_set(:find, selector)
    end
  
    def next(selector)
      child_set(:next, selector)
    end
  
    def eq(index)
      child_set(:eq, index)
    end
  
    def exist?
      self.length > 0
    end
    
    def filter(selector=nil, &block)
      if (block_given?)
        select(&block)
      else
        child_set(:filter, selector)
      end
    end
    
    def each
      len = length
      (0..len).each do |i|
        yield(eq(i))
      end
    end
  
    private

    def exec_jquery(member_expression)
      @browser.eval_js %|#{jquery_chain}#{member_expression}; return true;|
    end
  
    def eval_jquery(member_expression)
      @browser.eval_js %|return #{jquery_chain}#{member_expression};|
    end
  
    def child_set(name, *args)
      WrappedSet.new(@browser, self, name, *args)
    end
  
    def assert_exists
      # shouldn't have to do this
      tries = 0
      until exist? or tries == 10
        sleep 0.2
        tries += 1
      end
      raise "#{jquery_chain} contains no elements" if tries == 10
    end
  end

  class RootWrappedSet
    include WrappedSetMethods
  
    def initialize(browser, selector)
      @browser, @selector = browser, selector
    end
  
    def jquery_chain
      %{jQuery("#{@selector}")}
    end
  end

  class WrappedSet
    include WrappedSetMethods
  
    def initialize(browser, parent, method, selector)
      @browser, @parent, @method, @selector = browser, parent, method, selector
    end
  
    def jquery_chain
      %{#{@parent.jquery_chain}.#{@method.to_s}("#{@selector}")}
    end 
  end
end