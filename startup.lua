require("src")

Configuration = {
  http = {
    host = "*",
    port = "80"
  },
  
  document = {
    root = "htdocs",
    
    mimetypes = {
      ["%.css$"] = "text/css"
    },
    
    fallbacks = function(uri)
      return {
        uri,
        uri .. ".htm",
        uri .. ".html",
        uri .. "/index.htm",
        uri .. "/index.html"
      }
    end
  }
}

--//
--//  Convenience functions
--//

View = {}

function View.render(res)
  local file = Webserver.resolve(res)
  return new("src/view", file.read()).render()
end

--//
--//  Start the web server
--//

Webserver = new("src/webserver")
Webserver.start()
