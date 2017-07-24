local ledPin4=4
local ledPin0=0
gpio.mode(ledPin4,gpio.OUTPUT)
gpio.mode(ledPin0, gpio.OUTPUT)

-- register timers
led4 = tmr.create()
led0 = tmr.create()

local function ledBlink(pin)
    local _lighton=true
    
    return function()
        gpio.write(pin,(_lighton and gpio.LOW) or gpio.HIGH)
        _lighton= not _lighton
    end
end

led4:alarm(500, tmr.ALARM_AUTO, ledBlink(ledPin4))
led0:alarm(700, tmr.ALARM_AUTO, ledBlink(ledPin0))

function ledStop(led)
    local pin = (led == led0) and ledPin0 or ledPin4
    led:stop()
    gpio.write(pin, gpio.HIGH)    
end
