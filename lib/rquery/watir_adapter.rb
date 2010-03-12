module RQuery
  class WatirAdapter
    def initialize
      require 'watir-webdriver'
      @watir_browser = Watir::Browser.new(watir_driver)
    end
  
    def watir_driver
      (ENV['watir_driver'] || :firefox).to_sym
    end
  
    def visit(url)
      @watir_browser.goto(url)
    end
  
    def eval_js(js)
      @watir_browser.execute_script(js)
    end
  
    def title
      @watir_browser.title
    end
  
    def html
      @watir_browser.html
    end
  
    def close
      @watir_browser.close
    end
  
    def url
      @watir_browser.url
    end
  end
end