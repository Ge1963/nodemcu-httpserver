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
         <input type="number" name="led-1"><br/>
         <input type="submit" name="submit" value="Submit">
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
   else
      connection:send("ERROR WTF req.method is ", req.method)
   end

   connection:send('</body></html>')
end
