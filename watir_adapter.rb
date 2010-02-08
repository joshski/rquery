class WatirAdapter
  def initialize()
    @watir_browser = WatirBrowser.new
  end
  
  def visit(url)
    @watir_browser.goto(url)
  end
  
  def eval_js(js)
    @watir_browser.eval_js(js)
  end
  
  def title
    @watir_browser.title
  end
  
  def waiting_for_page_load
    @watir_browser.waiting_for_page_load do
      yield
    end
  end
end