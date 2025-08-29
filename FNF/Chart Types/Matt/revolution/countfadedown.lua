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
		doTweenAlpha('dumbshid2','goddsmitanothersquare', 0 , 0.001)
		setProperty('Wii_u_icon.alpha', 1)
		setProperty('bottom_right_button.alpha', 1)
	end
	if curBeat == 452 then
		doTweenAlpha('dumbshid2','goddsmitanothersquare', 1 , 0.001)
		setProperty('Wii_u_icon.alpha', 0)
		setProperty('bottom_right_button.alpha', 0)
	end
end