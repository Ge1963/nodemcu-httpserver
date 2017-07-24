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
         LED-0:<br/>
         <input type="number" name="led-0" placeholder="frequency in ms"><br/>
         <input type="submit" name="led-0-state" value="on">
         <input type="submit" name="led-0-state" value="off"><br/>
         LED-4:<br/>
         <input type="number" name="led-4" placeholder="frequency in ms"><br/>
         <input type="submit" name="led-4-state" value="on">
         <input type="submit" name="led-4-state" value="off">
      </form>
      ]===])
   elseif req.method == "POST" then
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
      if (rd["led-0-state"] or rd["led-4-state"]) then
         local led = rd["led-0-state"] and led0 or led4
         local state = rd["led-0-state"] or rd["led-4-state"]
         if (state == 'on') then
            led:start()
         else
            ledStop(led)
         end
      end
      if (rd["led-0"]) then
         led0:interval(rd["led-0"])
      end
      if (rd["led-4"]) then
         led4:interval(rd["led-4"])
      end
   else
      connection:send("ERROR WTF req.method is ", req.method)
   end

   connection:send('</body></html>')
end
