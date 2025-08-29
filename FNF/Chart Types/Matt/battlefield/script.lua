local stopEnd = true
function onStartCountdown()
	if stopEnd then
		setProperty('camGame.visible', false)
		setProperty('camHUD.visible', false)
		setProperty('skipCountdown', true)
        startVideo("challengers_approaching")
		stopEnd = false;
		return Function_Stop;     
	end
	return Function_Continue;
end

function onCreate()
    callMethod("preloadMidSongVideo", {"battlefield_intro"})
end
function onStepHit()
	if curStep == 12 then 
		callMethod("playMidSongVideo", {0})
	elseif curStep == 16 then 
		setProperty('camGame.visible', true)
		setProperty('camHUD.visible', true)
	end
end