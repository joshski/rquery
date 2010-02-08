if ENV['FIREWATIR']
  require 'firewatir'
  WatirBrowser = FireWatir::Firefox
  class FireWatir::Firefox
    def eval_js(js)
      raise js_eval("#{BROWSER_VAR}.contentDocument")
      begin
        js_eval(js)
      rescue => e
        if js_eval("document.window.location.href").match(/^chrome\:/)
          until not js_eval("document.window.location.href").match(/^chrome\:/)
            puts "waiting..."
          end
          eval_js(js)
        else
          raise "failed to eval:" + js
        end
      end
    end
  end
elsif ENV['CHROMEWATIR']
  require 'chromewatir'
  WatirBrowser = '???'
  raise "chromewatir not yet implemented!"
else
  case RUBY_PLATFORM
  when /darwin/
    require 'safariwatir'
    WatirBrowser = Watir::Safari
    module Watir
      class AppleScripter
        public :eval_js
        public :page_load
      end

      class Safari
        def eval_js(js)
          @scripter.eval_js("return " + js)
        end
        
        def waiting_for_page_load
          @scripter.page_load do
            yield
          end
        end
      end
    end
  when /win32|mingw/
    require 'watir'
    WatirBrowser = Watir::IE
    module Watir
      class IE
        def eval_js(js)
          begin
            self.document.parentWindow.eval(js)
          rescue
            puts "failed to eval js:\n#{js}"
          end
        end
        
        def waiting_for_page_load
          yield
          wait
        end      
      end
    end
  when /java/
    require 'celerity'
    WatirBrowser = Celerity::Browser
    class Celerity::Browser
      def eval_js(js)
        execute_script(js)
      end
      
      def waiting_for_page_load
        yield
        wait
      end
    end
  else
    raise "This platform is not supported (#{PLATFORM})"
  end
end