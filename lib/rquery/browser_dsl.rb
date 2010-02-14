module RQuery
  module BrowserDsl
    extend Forwardable
    def_delegators :browser, :visit, :jquery, :title, :html, :eval_js

    def browser
      @browser ||= Browser.new(adapter)
    end
  
    def adapter
      SeleniumAdapter.new
    end
  
    def close
      @browser.close unless @browser.nil?
      @browser = nil
    end
  end
end