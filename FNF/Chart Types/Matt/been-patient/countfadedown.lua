function onCreatePost()
	setProperty('camHUD.alpha', 0)
	setProperty('camOther.alpha', 0)
	setObjectCamera('subtitle', 'other')
	doTweenAlpha('dumbshid2','goddsmitanothersquare', 1 , 2)

	makeLuaSprite('logo', 'wii_funkin_logo', 0, 0)
	setGraphicSize('logo', 800,0)
	setScrollFactor('logo', 0, 0);
	screenCenter('logo');
	addLuaSprite('logo', true)
	setObjectCamera('logo', 'camOther')
	setProperty('logo.alpha', 0)

	setProperty('crowd1.alpha', 0)
	setProperty('crowd2.alpha', 0)
	setProperty('crowd3.alpha', 0)
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
	if curBeat == 31 then
		doTweenAlpha('dumbshid2','goddsmitanothersquare', 0 , 0.001)
	end
	if curBeat == 4 then
		doTweenAlpha('dumbshid', 'camOther', 1 ,2)
	end
	if curBeat == 31 then
		doTweenAlpha('dumbshid', 'camHUD', 0, 0.001)
	end
	if curBeat == 32 then
		doTweenAlpha('dumbshid', 'camHUD', 1 , 0.001)
	end
	if curBeat == 319 then
		doTweenAlpha('dumbshid2','goddsmitanothersquare', 1 , 0.001)
	end
	if curBeat == 327 then
		doTweenAlpha('dumbshid2','goddsmitanothersquare', 0 , 4)
	end
	if curBeat == 672 then
		doTweenAlpha('dumbshid2','goddsmitanothersquare', 1 , crochet*0.001*8)
		doTweenAlpha('logo','logo', 1 , crochet*0.001*6)
	end
end