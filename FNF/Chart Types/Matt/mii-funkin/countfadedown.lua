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
	if curBeat == 32 then
		doTweenAlpha('dumbshid2','goddsmitanothersquare', 0 , 0.001)
	end
	if curBeat == 224 then
		doTweenAlpha('dumbshid2','goddsmitanothersquare', 1 , 0.001)
	end
	if curBeat == 226 then
		doTweenAlpha('dumbshid2','goddsmitanothersquare', 0 , 5)
	end
	if curBeat == 255 then
		doTweenAlpha('dumbshid2','goddsmitanothersquare', 1 , 0.001)
	end
	if curBeat == 256 then
		doTweenAlpha('dumbshid2','goddsmitanothersquare', 0 , 0.001)
	end
end