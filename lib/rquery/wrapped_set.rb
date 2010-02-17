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
      each_index do |i|
        eval_jquery("[#{i}]").click
      end
    end
    
    def [](index)
      eval_jquery("[#{index}]")
    end
  
    def find(selector)
      child_set(:find, selector)
    end
  
    def next(selector)
      child_set(:next, selector)
    end
    
    def next_all(selector)
      child_set(:nextAll, selector)
    end
    
    def prev(selector)
      child_set(:prev, selector)
    end
    
    def prev_all(selector)
      child_set(:prevAll, selector)
    end
    
    def siblings(selector=nil)
      child_set(:siblings, selector)
    end
  
    def eq(index)
      child_set(:eq, index)
    end
    
    def is(selector)
      eval_jquery %|.is("#{selector}")|
    end
    
    def not(selector)
      child_set(:not, selector)
    end
    
    def add(selector)
      child_set(:add, selector)
    end
    
    def slice(from, to=nil)
      child_set(:slice, *[from, to].compact)
    end
    
    def children(selector=nil)
      child_set(:children, *(selector.nil? ? [] : [selector]))
    end
    
    def parent(selector=nil)
      child_set(:parent, *(selector.nil? ? [] : [selector]))
    end
    
    def parents(selector=nil)
      child_set(:parents, *(selector.nil? ? [] : [selector]))
    end
    
    def has_class(names)
      eval_jquery %|.hasClass("#{names}")|
    end
  
    def exist?
      self.length > 0
    end
    
    def empty?
      self.length == 0
    end
    
    def map_text
      map { |element| element.text }
    end
    
    def filter(selector=nil, &block)
      if (block_given?)
        select(&block)
      else
        child_set(:filter, selector)
      end
    end
    
    def each
      each_index do |i|
        yield(eq(i))
      end
    end
    
    def each_index
      (0..length-1).each do |i|
        yield(i)
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
      WrappedSet.new(@browser, self, name, *args.compact)
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
  
    def initialize(browser, parent, method, *args)
      @browser, @parent, @method, @args = browser, parent, method, args
    end
  
    def jquery_chain
      %{#{@parent.jquery_chain}.#{@method.to_s}(#{format_args})}
    end
    
    private
    
    def format_args
      @args.map { |arg| arg.inspect }.join(", ")
    end
  end
end