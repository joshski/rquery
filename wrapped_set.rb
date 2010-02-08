class WrappedSet
  def initialize(method, selector, parent, browser)
    @method, @selector, @parent, @browser = method, selector, parent, browser
  end
  
  def length
    @browser.eval_js "#{self.to_jquery}.length"
  end
  
  def val(value=nil)
    args = value.nil? ? "" : %|"#{value}"|
    @browser.eval_js "#{self.to_jquery}.val(#{args})"
  end
  
  def text()
    @browser.eval_js %|#{self.to_jquery}.text()|
  end
  
  def html
    @browser.eval_js %|#{self.to_jquery}.html()|
  end
  
  def attr(key)
    @browser.eval_js %|#{self.to_jquery}.attr("#{key}")|
  end
  
  def click
    js_click = %{
      (function() {
        var $el = #{self.to_jquery};
        var onClick = $el.attr('onclick');
        var ev_reference;
        var ev_capture = function(ev) { ev_reference = ev; };
        $el.bind('click', ev_capture);
        if (typeof onClick == 'function') { $el.bind('click', onClick); };
        $el.trigger('click');
        $el.unbind('click', ev_capture);
        if (typeof onClick == 'function') { $el.unbind('click', onClick); };
        if (ev_reference && !ev_reference.isDefaultPrevented()) {
          if ($el.is('a')) {
            window.location = $el.attr('href');
          }
          else if ($el.is('input') && $el.attr('type') == 'submit') {
            $($el).parents('form').submit();
          }
        };
        return true;
      })()
    }.gsub(/[\r\n]/, '')
    @browser.waiting_for_page_load do
      @browser.eval_js js_click
    end
  end
  
  def to_jquery
    %{#{@parent.nil? ? 'jQuery' : @parent.to_jquery + '.' + @method}("#{@selector}")}
  end
  
  def find(selector)
    WrappedSet.new('find', selector, self, @browser)
  end
  
  def next(selector)
    WrappedSet.new('next', selector, self, @browser)
  end
  
  def eq(index)
    WrappedSet.new('eq', index, self, @browser)
  end
end