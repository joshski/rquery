require 'selenium-webdriver'

module RQuery
  class SeleniumAdapter
    def initialize(selenium_driver=:firefox)
      @driver = Selenium::WebDriver::Driver.for(selenium_driver)
    end
    
    attr_reader :driver
  
    def visit(url)
      @driver.get(url)
    end
  
    def eval_js(js)
      @driver.execute_script(js)
    end
  
    def title
      @driver.title
    end
  
    def html
      @driver.page_source
    end
  
    def close
      @driver.quit
    end
  
    def url
      @driver.current_url
    end
  end
end