local request = {}

function request.method()
  return request.input:match("^([A-Z]+)%s")
end

function request.uri()
  return request.input:match("^[A-Z]+%s+(/.-)%s+HTTP.*\n")
end

function request.path()
  return request.uri():match("^(/[^%?]*)")
end

function request.params()
  local query = request.uri():match("%?(.-)$")
  local items = (query .. "&"):split("&")
  local out = {}

  for k, v in pairs(items)
  do
      local safe  = (v .. "=true"):split("=")
      local key   = safe[1]
      local value = safe[2]

      out[key] = value
  end
  
  return out
end

function request.new(client)
  request.socket = client
  request.input = ""
  
  local line, err = client:receive()
  do
    while line
    and line ~= ""
    and not err
    do
      request.input = request.input .. line .. "\n"
      line, err = client:receive()
    end
  end
end

function request.reply(response)
  local data = response.raw()
  request.socket:send(data)
  request.socket:shutdown("both")
end

return request