local herms = require 'herms-module'

return function (connection, req, args)
   dofile("httpserver-header.lc")(connection, 200, 'html')
   connection:send([===[
<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="utf-8">
   <title>GeBräu HERMS-I</title>
</head>
<body>
   <h1>GeBräu HERMS-I</h1>
]===])

   local t = herms.readAllTemps()
   connection:send('<div>')
   connection:send(string.format('HLT: %.1f°C/%.1f°C<br />', t.hlt, t.set))
   connection:send(string.format('Coil: %.1f°C<br />', t.coil))
   connection:send(string.format('MT: %.1f°C<br />', t.mt))
   connection:send('</div>')
   connection:send([===[
   <form method="POST">
      HLT set-temperature:<br/>
      <input type="number" name="hlt-set-temp" placeholder="°C"><br/>
      <input type="submit" name="submit" value="set">
   </form>
   ]===])
   if req.method == "POST" then
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
      local temp = rd["hlt-set-temp"]
      if temp then herms.setHltTemp(tonumber(temp)) end
   else
      connection:send("ERROR req.method is ", req.method)
   end

   connection:send('</body></html>')
end
