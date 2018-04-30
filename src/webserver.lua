local webserver = {}

socket = require("socket")

function webserver.new()
  webserver.host = Configuration.http.host
  webserver.port = Configuration.http.port
  webserver.root = Configuration.document.root
end

--//
--//  Returns an instance of a file from the provided URI.
--//
function webserver.resolve(uri)
  local fallbacks = Configuration.document.fallbacks(uri)
  local file = nil
  
  for i = 1, #fallbacks
  do
    if file == nil
    or file.exists() == false
    then
      file = new("src/file", webserver.root .. fallbacks[i])
    end
  end
  
  return file
end

function webserver.start()
  print(
    string.format(
      "Serving '%s/' as %s on port %s.",
        webserver.root,
        webserver.host,
        webserver.port))

  local server = socket.bind(webserver.host, webserver.port)
  local i, p = server:getsockname()

  while true
  do
    try(
    function()
      request = new("src/request", server:accept())
      response = new("src/response")
      
      local continue = true
        and request.path() ~= nil
        and request.path() ~= "favicon.ico"
        
      if continue
      then
        print(request.method() .. " " .. request.path())
        
        local file
        local render
        
        try(
        function()
          file = webserver.resolve(request.path())
          view = new("src/view", file.read())
          response.set(file.mime(), view.render())
        end)
    
        catch(
        function()
          response.status = "500 Internal Server Error"
          response.headers["Content-Type"] = "text/plain"
          response.set(err)
        end)
        
      else
        response.status = "500 Error"
      end
    end)

    catch(
    function()
    end)

    request.reply(response)
  end
end

return webserver