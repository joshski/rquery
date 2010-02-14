require 'selenium-webdriver'

class SeleniumAdapter
  def initialize
    @driver = Selenium::WebDriver::Driver.for(selenium_driver)
  end
  
  def selenium_driver
    (ENV['selenium_driver'] || :firefox).to_sym
  end
  
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