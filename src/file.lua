local file = {}

function file.new(...)
  local args = {...}
  file.path  = args[1]
end

function file.exists()
  local handle = io.open(file.path, "r")
  
  if type(handle) == "userdata"
  then
    handle:close()
    return true
  end
  
  return false
end

function file.read()
  local handle = io.open(file.path, "r")
  local data = ""

  if type(handle) == "userdata"
  then
      data = handle:read("*all")
      handle:close()
  end

  return data
end

function file.mime()
  for key, value in pairs(Configuration.document.mimetypes)
  do
    if file.path:match(key)
    then
      return value
    end
  end
end

return file