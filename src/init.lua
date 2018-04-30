--//
--//  Instance initializer for Lua scripts that return itself as a table.
--//
--//  Example:  (myclass.lua)
--//
--//    local myclass = {}
--//
--//    function myclass.new(...)
--//      local args = {...}
--//      myclass.x = 0
--//      myclass.y = 0
--//      myclass.label = "A new myclass instance!"
--//    end
--//
--//    return myclass
--//
function new(str, ...)
  local instance = loadfile(string.format("%s.lua", str))()
  
  if instance.new
  then
    instance.new(...)
  end
  
  return instance
end

--//
--//  Error trapping using a familiar try and catch block syntax.
--//  This is useless without calling catch(func)!
--//
--//  Example:
--//
--//    try(function()
--//        unsafeCodeHere()
--//    end)
--//
--//    catch(function(err)
--//        print("Reason: " .. err)
--//        errorHandlingHere()
--//    end)
--//
function try(func)
  _try = func
end

--//
--//  Note: The catch block must be called in order for the try block to be called.
--//
function catch(func)
  _, err = pcall(_try)
  
  if err
  then
    func(err)
  end
end