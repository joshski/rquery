module RQuery
  module BrowserDsl
    extend Forwardable
    def_delegators :browser, :visit, :jquery, :title, :html, :eval_js, :url

    $current_adapter = (ENV["selenium_driver"] || :firefox).to_sym

    def browser
      $browser ||= Browser.new(create_adapter)
    end
  
    def create_adapter
      SeleniumAdapter.new($current_adapter)
    end
  
    at_exit do
      RQuery::BrowserDsl.close unless ENV["keep_browser_open"] == "true"
    end
    
    def self.close
      $browser.close unless $browser.nil?
      $browser = nil      
    end
    
    def self.adapter=(adapter_name)
      adapter = adapter_name.to_sym
      if adapter != $current_adapter
        self.close
        $current_adapter = adapter
      end
    end
  end
end