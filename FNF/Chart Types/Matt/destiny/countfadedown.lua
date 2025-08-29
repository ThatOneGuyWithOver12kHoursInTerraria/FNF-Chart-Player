function onCreatePost()
	makeLuaSprite('goddsmitanothersquare', '', 0, 0)
	makeGraphic('goddsmitanothersquare', 1, 1, '000000')
	setGraphicSize('goddsmitanothersquare', 3000,3000)
	setScrollFactor('goddsmitanothersquare', 0, 0);
	screenCenter('goddsmitanothersquare');
	addLuaSprite('goddsmitanothersquare', true)
	setProperty('goddsmitanothersquare.alpha', 1)

	setProperty('camHUD.alpha', 1)
	doTweenAlpha('dumbshid2','goddsmitanothersquare', 0 , 2)
end
function onCreate()
	setProperty('skipCountdown', true)
end
function onBeatHit()
	if not shadersEnabled then 
		if curBeat == 296 then
			doTweenAlpha('dumbshid2','goddsmitanothersquare', 1 , 2)
		end
	
		if curBeat == 304 then
			doTweenAlpha('dumbshid2','goddsmitanothersquare', 0 , 0.001)
		end
	
		if curBeat == 304 then
			doTweenAlpha('dumbshid', 'camHUD', 0 , 0.001)
		end
	
		if curBeat == 305 then
			doTweenAlpha('dumbshid', 'camHUD', 1 , 0.001)
		end
	end
end