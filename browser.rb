class Browser
  def initialize(adapter)
    @adapter = adapter
  end
  
  def jquery(selector)
    inject_jquery_if_necessary
    WrappedSet.new('find', selector, nil, self)
  end
  
  def visit(url)
    @adapter.visit(url)
  end
  
  def title
    @adapter.title
  end 
  
  def eval_js(js)
    puts js
    @adapter.eval_js(js)
  end
  
  def waiting_for_page_load
    @adapter.waiting_for_page_load do
      yield
    end
  end
  
  private
  
  def inject_jquery_if_necessary
    if @adapter.eval_js("typeof(jQuery) == 'undefined'").to_s == "true"
      File.open(File.expand_path(File.join(File.dirname(__FILE__), "jquery.js")), "r") do |file|
        @adapter.eval_js file.readlines.join('')
        @adapter.eval_js "window.jquery=function() {return jQuery.apply(this, arguments);}"
      end
    end
    raise "failed to inject jquery " if @adapter.eval_js("typeof(jQuery) == 'undefined'").to_s == "true"
  end
end