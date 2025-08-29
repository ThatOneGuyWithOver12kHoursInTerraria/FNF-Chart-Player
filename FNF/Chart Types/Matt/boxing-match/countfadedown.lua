function onCreatePost()
	setProperty('camHUD.alpha', 1)
end
function onCreate()
	--setProperty('skipCountdown', true)
end
function onBeatHit()
	if curBeat == 4 then
		doTweenAlpha('dumbshid2','goddsmitanothersquare', 0 , 6)
	end
	if curBeat == 385 then
		doTweenAlpha('dumbshid', 'camHUD', 0 , 0.001)
	end
	if curBeat == 450 then
		doTweenAlpha('dumbshid', 'camHUD', 1 , 1)
	end
	
end