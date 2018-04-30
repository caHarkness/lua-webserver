local view = {}

function view.new(...)
  local args = {...}
  view.text = args[1]
end

function view.render()
  local render = view.text
  
  viewbag = {}
  render = string.gsub(
    render,
    "%[%[(.-)%]%]",
    "print([[%1]])")
  
  render = string.gsub(
    render,
    "<%%[^=](.-)%%>",
    function(m)
      local script = [[
        local output = ""
        local function print(str)
          output = output .. str
        end
        %s
        return output
      ]]
      
      script = string.format(script, m)
      return loadstring(script)()
    end);
  
  render = string.gsub(
    render,
    "<%%=(.-)%%>",
    function(c)
      return loadstring("return tostring(" .. c .. ")")()
    end)
  
  return render
end

return view