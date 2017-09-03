local led = require 'led-module'

return function (connection, req, args)
   dofile("httpserver-header.lc")(connection, 200, 'html')
   connection:send([===[
<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="utf-8">
   <title>NodeMCU LED control</title>
</head>
<body>
   <h1>NodeMCU LED control</h1>
]===])

   if req.method == "GET" then
      connection:send([===[
      <form method="POST">
         LED-1:<br/>
         <input type="number" name="led-1" placeholder="frequency in ms"><br/>
         <input type="submit" name="led-1-state" value="on">
         <input type="submit" name="led-1-state" value="off"><br/>
         LED-2:<br/>
         <input type="number" name="led-2" placeholder="frequency in ms"><br/>
         <input type="submit" name="led-2-state" value="on">
         <input type="submit" name="led-2-state" value="off">
      </form>
      ]===])
   elseif req.method == "POST" then
      -- produce HTML response
      local rd = req.getRequestData()
      connection:send('<h2>Received the following values:</h2>')
      connection:send("<ul>\n")
      for name, value in pairs(rd) do
          connection:send('<li><b>')
          connection:send(name)
          connection:send(':</b> ')
          connection:send(tostring(value))
          connection:send("<br></li>\n")
      end
      connection:send("</ul>\n")

      -- control led-module accordingly
      local state = rd["led-1-state"]
      if state then led.set(1, state == 'on') end
      state = rd["led-2-state"]
      if state then led.set(2, state == 'on') end
      local millis = rd["led-1"]
      if millis then led.blink(1, millis) end
      millis = rd["led-2"]
      if millis then led.blink(2, millis) end
   else
      connection:send("ERROR req.method is ", req.method)
   end

   connection:send('</body></html>')
end
