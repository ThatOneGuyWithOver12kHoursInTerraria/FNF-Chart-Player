function onCreatePost()
	setProperty('camHUD.alpha', 1)
doTweenAlpha('dumbshid2','goddsmitanothersquare', 0 , 2)
end
function onCreate()
	setProperty('skipCountdown', true)
--makeLuaSprite('goddsmitanothersquare', nil, 0, 0) 		luaSpriteMakeGraphic('goddsmitanothersquare', 1920, 1080, '000000') 		setScrollFactor('goddsmitanothersquare', 0, 0); 		screenCenter('goddsmitanothersquare'); 		addLuaSprite('goddsmitanothersquare', true)
--setProperty('goddsmitanothersquare.alpha', 0)
end
function onBeatHit()
	if curBeat == 4 then
		--doTweenAlpha('dumbshid2','goddsmitanothersquare', 0 , 0.001)
	end
end