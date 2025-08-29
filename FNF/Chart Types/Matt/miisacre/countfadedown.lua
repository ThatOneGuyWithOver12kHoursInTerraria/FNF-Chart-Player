function onCreatePost()
	setProperty('camHUD.alpha', 1)
doTweenAlpha('dumbshid2','goddsmitanothersquare', 1 , 2)
end
function onCreate()
	setProperty('skipCountdown', true)
	makeLuaSprite('goddsmitanothersquare', nil, 0, 0)
	luaSpriteMakeGraphic('goddsmitanothersquare', 1, 1, '000000')
	setGraphicSize('goddsmitanothersquare', 3000,3000)
	setScrollFactor('goddsmitanothersquare', 0, 0);
	screenCenter('goddsmitanothersquare');
	addLuaSprite('goddsmitanothersquare', true)
	setProperty('goddsmitanothersquare.alpha', 1)
end
function onBeatHit()
	if curBeat == 4 then
		doTweenAlpha('dumbshid2','goddsmitanothersquare', 0 , 9)
	end
	if curBeat == 60 then
		doTweenAlpha('dumbshid2','goddsmitanothersquare', 1 , 0.001)
	end
	if curBeat == 64 then
		doTweenAlpha('dumbshid2','goddsmitanothersquare', 0 , 0.001)
	end
	if curBeat == 485 then
		doTweenAlpha('dumbshid2','goddsmitanothersquare', 1 , 0.001)
	end
end