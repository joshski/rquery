module RQuery
  module WrappedSetMethods
    include Enumerable

    def selector
      eval_jquery_property :selector
    end
    
    def length
      eval_jquery_property :length
    end
    
    def size
      length
    end
    
    def get(index=nil)
      index.nil? ? self.to_a : self.eq(index)
    end

    def val(value=nil)
      if value.nil?
        eval_jquery_method :val
      else
        self.each do |set|
          set_element_value set[0], value
        end
      end
    end
  
    def text
      assert_exists
      eval_jquery_method :text
    end
  
    def html
      eval_jquery_method :html
    end
    
    def and_self
      child_set :andSelf
    end

    def attr(attribute_name)
      eval_jquery_method :attr, attribute_name
    end
    
    def css(property_name)
      eval_jquery_method :css, property_name
    end
  
    def click
      assert_exists
      each_index do |i|
        self[i].click
      end
    end
    
    def [](index)
      eval_jquery("[#{index}]")
    end
    
    def first
      self.eq(0)
    end
  
    def find(selector)
      child_set(:find, selector)
    end
    
    def index(subject=nil)
      if subject.nil?
        eval_jquery_method :index
      elsif subject.respond_to?(:jquery_chain)
        eval_jquery ".index(#{subject.jquery_chain})"
      else
        eval_jquery_method :index, subject
      end
    end
  
    def next(selector)
      child_set(:next, selector)
    end
    
    def next_all(selector)
      child_set(:nextAll, selector)
    end
    
    def next_until(selector)
      child_set(:nextUntil, selector)
    end
    
    def prev(selector)
      child_set(:prev, selector)
    end
    
    def prev_all(selector)
      child_set(:prevAll, selector)
    end
    
    def prev_until(selector)
      child_set(:prevUntil, selector)
    end
    
    def siblings(selector=nil)
      child_set(:siblings, selector)
    end
  
    def eq(index)
      child_set(:eq, index)
    end
    
    def is(selector)
      eval_jquery_method :is, selector
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
    
    def closest(selector)
      child_set(:closest, selector)
    end
    
    def has_class(names)
      eval_jquery_method :hasClass, names
    end
    
    def has(selector)
      child_set(:has, selector)
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
    
    def tag_name
      eval_jquery "[0].tagName"
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
    
    def inspect
      "#<WrappedSet #{jquery_chain} length=#{length}>"
    end
    
    def assert_exists
      # shouldn't have to do this
      tries = 0
      until exist? or tries == 20
        sleep 0.3
        tries += 1
      end
      raise "#{jquery_chain} contains no elements" if tries == 10
    end
  
    private

    def exec_jquery(member_expression)
      @browser.eval_js %|#{jquery_chain}#{member_expression}; return true;|
    end
  
    def eval_jquery(member_expression)
      @browser.eval_js %|return #{jquery_chain}#{member_expression};|
    end
    
    def eval_jquery_method(name, *args)
      eval_jquery %|.#{name}(#{format_args(*args)})|
    end
    
    def eval_jquery_property(name)
      eval_jquery %|.#{name}|
    end
    
    def format_args(args=[])
      args.map { |arg| format_arg(arg) }.join(", ")
    end
    
    def format_arg(arg)
      if arg.nil?
        "null"
      elsif arg.respond_to?(:jquery_chain)
        arg.jquery_chain
      else
        arg.inspect
      end
    end
    
    def set_element_value(element, value)
      case element.tag_name.downcase 
        when "select" then
          # hmm I think this should work, but doesn't
          # set.find("option").detect { |opt| opt.text == value }.first.select
          # selenium-webdriver specific
          element.find_elements(:tag_name, "option").select { |option| option.text == value }.first.select
        when "input" then
          element.clear
          element.send_keys value
      end
    end
    
    def child_set(name, *args)
      WrappedSet.new(@browser, self, name, *args.compact)
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
      %{#{@parent.jquery_chain}.#{@method.to_s}(#{format_args(@args)})}
    end
  end
end