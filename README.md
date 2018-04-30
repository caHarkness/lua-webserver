# lua-webserver
A simple Lua web server with an ASP.NET Razor view-like engine

## Features
1. Object oriented style code with table instantiation with `new("src/example.lua", ...)`
2. Familiar try/catch block error trapping using `try(function() ... end)` and `catch(function(err) ... end)`
2. ASP.NET Razor-like view rendering with inline Lua code using `<% ... %>` and `<%= ... %>`

## Notes
Code executed in a rendered view is persistent. For example, if you call `Visitors = Visitors + 1` when rendering a view, the value of `Visitors` is persistent between requests.
