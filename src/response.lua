local response = {}

function response.new()
  response.status  = "200 OK"
  response.body    = ""
  response.headers = {
    ["Date"]           = os.date("%a, %d %b %Y %H:%M:%S UTC"),
    ["Content-Type"]   = "text/html",
    ["Content-Length"] = 0,
    ["Connection"]     = "close"
  }
end

function response.set(mime, body)
  response.body = body
  response.headers["Content-Type"]   = mime
  response.headers["Content-Length"] = #body
end

function response.raw()
  local out = string.format("HTTP/1.1 %s\n", response.status)
  
  for key, value in pairs(response.headers)
  do
    out = out .. string.format("%s: %s\n", key, value)
  end
  
  out = out .. string.format("\n%s\n\n", response.body)
  return out
end

return response