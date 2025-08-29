function onCreatePost()
	setProperty('camHUD.alpha', 0)
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
	if curBeat == 16 then
		doTweenAlpha('dumbshid2','goddsmitanothersquare', 0 , 10)
	end
	if curBeat == 72 then
		doTweenAlpha('dumbshid', 'camHUD', 1 , 3)
	end
	
end