local cutsceneData = {
    {2750, 1, 0, false},
    {4500, 0, 1, false},
    {6500, 0, 2, false},
    {7700, 2, 3, false},
    {8500, 3, 4, false},
    {12300, 0, 5, false},
    {16750, 4, 6, false},
    {18390, 5, 7, false},

    {111200, 6, 8, false},
    {117250, 7, 8, false},
    {123960, 8, 8, false},
    {123960, 8, 8, false},
    {128400, 9, 8, false},

    {268860, 1, 7, false},
    {270130, 5, 7, false},
    {274410, 0, 5, false},
    {277140, 2, 6, false},
    {277560, 5, 6, false},
}
local curMattFrame = 0
local curShagFrame = 0
local lastMattFrame = 0
local lastShagFrame = 0
local mattFrameMax = 9
local shagFrameMax = 8
function onCreate()
    setProperty('skipCountdown', true)
end
function onCreatePost()
    

    makeLuaSprite('cutsceneBG', 'long-awaited/laBG')
    setObjectCamera('cutsceneBG', 'hud')
    addLuaSprite('cutsceneBG', true)
    setScrollFactor('cutsceneBG', 0.1, 0.1)

    


    makeLuaSprite('matt', 'long-awaited/la_matt0', 107, 185)
    setObjectCamera('matt', 'hud')
    addLuaSprite('matt', true)

    makeLuaSprite('shag', 'long-awaited/la_shag0', 714, 37)
    setObjectCamera('shag', 'hud')
    addLuaSprite('shag', true)

    --490
    --170, 468

    for i = 0, mattFrameMax do
        makeLuaSprite('matt'..i, 'long-awaited/la_matt'..i, 107, 185)
        setObjectCamera('matt'..i, 'hud')
        addLuaSprite('matt'..i, true)
        setProperty('matt'..i..'.alpha', 0.001)

        if i >= 6 then 
            setProperty('matt'..i..'.x', 170)
            setProperty('matt'..i..'.y', 468)
            --setScrollFactor('shag'..i..'.y', 0.7, 1.0)
        end
    end

    for i = 0, shagFrameMax do
        makeLuaSprite('shag'..i, 'long-awaited/la_shag'..i, 714, 37)
        setObjectCamera('shag'..i, 'hud')
        addLuaSprite('shag'..i, true)
        setProperty('shag'..i..'.alpha', 0.001)
        if i >= 8 then
            setProperty('shag'..i..'.x', 490)
            setProperty('shag'..i..'.y', 60)
            setScrollFactor('shag'..i..'.y', 1.5, 1.5)
        end
    end

    setProperty('matt'..curMattFrame..'.alpha', 1)
    setProperty('shag'..curShagFrame..'.alpha', 1)

    makeLuaSprite('cutsceneBarTop', '')
    makeGraphic('cutsceneBarTop', 1, 1, '#000000')
    setGraphicSize('cutsceneBarTop', 1280, 70)
    setObjectCamera('cutsceneBarTop', 'other')
    addLuaSprite('cutsceneBarTop', true)

    makeLuaSprite('cutsceneBarBot', '', 0, 720-70)
    makeGraphic('cutsceneBarBot', 1, 1, '#000000')
    setGraphicSize('cutsceneBarBot', 1280, 70)
    setObjectCamera('cutsceneBarBot', 'other')
    addLuaSprite('cutsceneBarBot', true)

    makeLuaSprite('blackBG', nil, 0, 0)
	luaSpriteMakeGraphic('blackBG', 1, 1, '000000')
	setGraphicSize('blackBG', 3000,3000)
	setScrollFactor('blackBG', 0, 0);
	screenCenter('blackBG');
	addLuaSprite('blackBG', true)
    setObjectCamera('blackBG', 'hud')
	setProperty('blackBG.alpha', 1)

    --setObjectOrder('subtitle', getObjectOrder('blackBG'))
    setObjectCamera('subtitle', 'other')
    --setObjectCamera('title', 'other')
    --for i = 0, 10 do
    --    setObjectCamera('introBar'..i, 'other')
    --end
end

function onUpdate(elapsed)
    local songPos = getSongPosition()
    for i = 1, #cutsceneData do 
        if not cutsceneData[i][4] and songPos >= cutsceneData[i][1] then 
            cutsceneData[i][4] = true


            --setProperty('matt'..curMattFrame..'.visible', false)
            --setProperty('shag'..curShagFrame..'.visible', false)
            lastMattFrame = curMattFrame
            lastShagFrame = curShagFrame
            curMattFrame = cutsceneData[i][2]
            curShagFrame = cutsceneData[i][3]
            if lastMattFrame ~= curMattFrame then 
                doTweenAlpha('mattin', 'matt'..lastMattFrame, 0.001, 0.2)
                doTweenAlpha('mattout', 'matt'..curMattFrame, 1, 0.2)
            end
            if lastShagFrame ~= curShagFrame then 
                doTweenAlpha('shagin', 'shag'..lastShagFrame, 0.001, 0.2)
                doTweenAlpha('shagout', 'shag'..curShagFrame, 1, 0.2)
            end
           -- setProperty('matt'..curMattFrame..'.visible', true)
            --setProperty('shag'..curShagFrame..'.visible', true)
        end
    end
end

function onSongStart()
    doTweenAlpha('blackBG','blackBG', 0, 4)
    doTweenZoom('camHUD','camHUD', 1.2, crochet*0.001*0.25*255, 'linear')
end
function onStepHit()
    if curStep == 240 then 
        doTweenAlpha('blackBG','blackBG', 1, crochet*0.001*3.8)
    elseif curStep == 256 then 
        setProperty('camHUD.zoom', 1)
        setProperty('cutsceneBG.alpha', 0)
        setProperty('cutsceneBarTop.alpha', 0)
        setProperty('cutsceneBarBot.alpha', 0)
        setProperty('matt.alpha', 0)
        setProperty('shag.alpha', 0)
        for i = 0, mattFrameMax do
            setProperty('matt'..i..'.alpha', 0.001)
        end
        for i = 0, shagFrameMax do
            setProperty('shag'..i..'.alpha', 0.001)
        end
        doTweenAlpha('blackBG','blackBG', 0, crochet*0.001*3.8)
    elseif curStep == 1408 then
        doTweenZoom('camHUD','camHUD', 1.2, crochet*0.001*4*15.75, 'linear')
        doTweenX('camHUDx','camHUD.scroll', -150, crochet*0.001*4*15.75, 'linear')
        doTweenY('camHUDy','camHUD.scroll', 100, crochet*0.001*4*15.75, 'linear')
        setProperty('cutsceneBG.alpha', 1)
        setProperty('cutsceneBarTop.alpha', 1)
        setProperty('cutsceneBarBot.alpha', 1)
        setProperty('cutsceneBG.flipX', true)
        setProperty('blackBG.alpha', 1)
        doTweenAlpha('blackBG','blackBG', 0, crochet*0.001*8)
        setProperty('camHUD.zoom', 1)
        setProperty('camZooming', false)

        setProperty('matt6.alpha', 1)
        setProperty('shag8.alpha', 1)
        setProperty('matt.alpha', 1)
        loadGraphic('matt', 'long-awaited/la_matt6')
        updateHitbox('matt')
        setProperty('matt.x', 170)
        setProperty('matt.y', 468)
    elseif curStep == 1658 then
        setProperty('camHUD.scroll.x', 0)
        setProperty('camHUD.scroll.y', 0)
        setProperty('blackBG.alpha', 1)
    elseif curStep == 1664 then
        setProperty('camHUD.scroll.x', 0)
        setProperty('camHUD.scroll.y', 0)
        setProperty('blackBG.alpha', 0)
        setProperty('camHUD.zoom', 1)
        setProperty('cutsceneBG.alpha', 0)
        setProperty('cutsceneBarTop.alpha', 0)
        setProperty('cutsceneBarBot.alpha', 0)
        setProperty('matt.alpha', 0)
        setProperty('shag.alpha', 0)
        for i = 0, mattFrameMax do
            setProperty('matt'..i..'.alpha', 0.001)
        end
        for i = 0, shagFrameMax do
            setProperty('shag'..i..'.alpha', 0.001)
        end

    elseif curStep == 3248 then
        setProperty('camGame.alpha', 0)
    elseif curStep == 3280 then
        setProperty('camGame.alpha', 1)
    elseif curStep == 3664 then
        doTweenAlpha('blackBG','blackBG', 1, crochet*0.001*3.5)
    elseif curStep == 3680 then
        doTweenZoom('camHUD','camHUD', 1.2, crochet*0.001*4*8, 'linear')
        doTweenAlpha('blackBG','blackBG', 0, crochet*0.001*4)
        setProperty('cutsceneBG.alpha', 1)
        setProperty('cutsceneBarTop.alpha', 1)
        setProperty('cutsceneBarBot.alpha', 1)
        setProperty('cutsceneBG.flipX', false)
        setProperty('camHUD.zoom', 1)
        setProperty('camZooming', false)

        loadGraphic('matt', 'long-awaited/la_matt0')
        updateHitbox('matt')
        setProperty('matt.x', 107)
        setProperty('matt.y', 185)
        setProperty('matt.alpha', 1)
        setProperty('shag.alpha', 1)
    elseif curStep == 3808 then
        doTweenAlpha('blackBG','blackBG', 1, crochet*0.001*16)
    end
end