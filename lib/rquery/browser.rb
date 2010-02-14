module RQuery
  class Browser
    def initialize(adapter)
      @adapter = adapter
    end
  
    def jquery(selector)
      inject_jquery_if_necessary
      RootWrappedSet.new(self, selector)
    end
  
    def visit(url)
      @adapter.visit(url)
    end
  
    def title
      @adapter.title
    end 
  
    def eval_js(js)
      inject_jquery_if_necessary
      @adapter.eval_js(js)
    end
  
    def close
      @adapter.close
    end
  
    def html
      @adapter.html
    end
  
    def url
      @adapter.url
    end
  
    private
  
    def inject_jquery_if_necessary
      unless jquery_defined?
        @adapter.eval_js jquery_src
        @adapter.eval_js define_lower_case_jquery
      end
      raise "failed to inject jquery " unless jquery_defined?
    end
  
    def jquery_defined?
      @adapter.eval_js("return typeof jQuery;") != "undefined"
    end
  
    def jquery_src
      @@jquery_src ||= File.read(File.join(File.dirname(__FILE__), "jquery.js"))
    end
  
    def define_lower_case_jquery
      "window.jquery=function() {return jQuery.apply(this, arguments);}"
    end
  end
end