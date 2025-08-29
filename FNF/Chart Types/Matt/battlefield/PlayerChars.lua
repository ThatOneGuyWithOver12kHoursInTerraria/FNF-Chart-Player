local characterList = {}

local charToNoteTypeMap = {
    {'miiswordfighter', 'Darnote1'},
    {'miigunner', 'Darnote2'},
}

function onCreatePost()
    luaDebugMode = true
    triggerEvent('createCharacter', 'miiswordfighter', '')
    triggerEvent('createCharacter', 'miigunner', '')


    createInstance('platform', "objects.Character", {0, 0, 'bf-battlefieldAnims', true})
    setProperty('platform.x', getProperty('boyfriend.x'))
    setProperty('platform.y', getProperty('boyfriend.y'))
    playAnim('platform', 'platform')
    addInstance('platform', true)
    setProperty('platform.alpha', 0.001)

    createInstance('bfAnims', "objects.Character", {0, 0, 'bf-battlefieldAnims', true})
    setProperty('bfAnims.x', getProperty('boyfriend.x'))
    setProperty('bfAnims.y', getProperty('boyfriend.y'))
    playAnim('bfAnims', 'getup')
    addInstance('bfAnims', true)
    setProperty('bfAnims.alpha', 0.001)

    setProperty('miiswordfighter.x', getProperty('dad.x')-350)
    setProperty('miiswordfighter.y', getProperty('dad.y')-70)
    setProperty('miigunner.x', getProperty('dad.x')-570)
    setProperty('miigunner.y', getProperty('dad.y')-30)

    setProperty('dad.x', getProperty('dad.x')+25)

    setObjectOrder('miigunner', getObjectOrder('dadGroup')+1)
    setObjectOrder('miiswordfighter', getObjectOrder('dadGroup')-1)

    for i = 0, getProperty('unspawnNotes.length')-1 do
        for j = 0, #characterList-1 do
            if string.find(getPropertyFromGroup('unspawnNotes', i, 'noteType'), getCharNoteType(characterList[j+1])) 
                and not string.find(getPropertyFromGroup('unspawnNotes', i, 'noteType'), "-duet") then 
                setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
            end
        end
    end

    setProperty('healthBar.visible', false)
    setProperty('iconP1.visible', false)
    setProperty('iconP2.visible', false)

    createSmashIcon('smashIcon0', 'huds_1', -3)
    createSmashIcon('smashIcon1', 'huds_2', -1)
    createSmashIcon('smashIcon2', 'huds_3', 1)
    createSmashIcon('smashIcon3', 'huds_bf', 3)

    setProperty('health', 2)

    setupSmashCountdown()
end

local iTimes = {0, 0, 0, 0}

function createSmashIcon(name, sprite, pos)
    makeLuaSprite(name, 'battlefield/hud/'..sprite, 0, getProperty('healthBar.y'))
    screenCenter(name, 'x')
    setProperty(name..'.x', getProperty(name..'.x') + (pos * 150))
    setObjectCamera(name, 'hud')
    addLuaSprite(name, true)

    for i = 0, 3 do

        makeLuaText(name..'textShadow'..i, "0", 0, 5 + 100 + getProperty(name..'.x')+i*(40), getProperty('healthBar.y')+50+5)
        setTextSize(name..'textShadow'..i, 64)
        setTextColor(name..'textShadow'..i, '000000')
        addLuaText(name..'textShadow'..i)

        makeLuaText(name..'text'..i, "0", 0, 100 + getProperty(name..'.x')+i*(40), getProperty('healthBar.y')+50)
        setTextSize(name..'text'..i, 64)
        addLuaText(name..'text'..i)

        initLuaShader('smashNumbers')
        setSpriteShader(name..'text'..i, 'smashNumbers')
        setSpriteShader(name..'textShadow'..i, 'smashNumbers')
        --setShaderFloatArray(name..'text'..i, 'vertexXOffset', {0, 0, 0, 0})
        setShaderFloat(name..'text'..i, 'iTime', 0)
        setShaderFloat(name..'textShadow'..i, 'iTime', 0)
        setShaderFloat(name..'text'..i, 'doOverrideColor', 0.0)
        setShaderFloat(name..'textShadow'..i, 'doOverrideColor', 0.0)
    end
    setTextSize(name..'text3', 32)
    setTextString(name..'text3', "%")
    setProperty(name..'text3.y', getProperty('healthBar.y')+75)
    setTextSize(name..'textShadow3', 32)
    setTextString(name..'textShadow3', "%")
    setProperty(name..'textShadow3.y', getProperty('healthBar.y')+75+3)

    updateSmashIcon(name, 0, 0, false)
end

function updateSmashIcon(name, percent, num, doShake)
    local percentStr = ""..percent
    
    for i = 0, 2 do
        setProperty(name..'text'..i..'.visible', false)
        setProperty(name..'textShadow'..i..'.visible', false)
    end

    local color = 'FFFFFF'
    if percent > 80 then 
        color = 'e0200e'
    elseif percent > 65 then 
        color = 'e23f00'
    elseif percent > 50 then 
        color = 'e25500'
    elseif percent > 30 then 
        color = 'e7d133'
    elseif percent > 15 then
        color = 'e7dc8e'
    end

    local index = 0
    for i = 3-#percentStr, 3 do 
        setProperty(name..'text'..i..'.visible', true)
        setProperty(name..'textShadow'..i..'.visible', true)

        setProperty(name..'text'..i..'.x', 100 + getProperty(name..'.x') + index * (40))
        setProperty(name..'textShadow'..i..'.x', 5 + 100 + getProperty(name..'.x') + index * (40))

        setTextColor(name..'text'..i, color)

        if i ~= 3 then 
            setTextString(name..'text'..i, string.sub(percentStr,index+1,index+1))
            setTextString(name..'textShadow'..i, string.sub(percentStr,index+1,index+1))
        end

        index = index + 1
    end

    if doShake then 
        iTimes[num+1] = 0.25
    end
end

function getFormattedHealth()
    local hp = math.floor(-((getProperty('health') / 2) * 100) + 100)
    if hp > 100 then 
        hp = 100
    end
    if hp < 0 then 
        hp = 0;
    end
    return hp;
end

function noteMiss(id, data, typ, isSus)
    updateSmashIcon('smashIcon3', getFormattedHealth(), 3, true)
end
function noteMissPress(dir)
    updateSmashIcon('smashIcon3', getFormattedHealth(), 3, true)
end

function onUpdate(elapsed)
    if not shadersEnabled then 
        return
    end
    for i = 0, 3 do 
        --update iTime
        iTimes[i+1] = iTimes[i+1] - elapsed
        if iTimes[i+1] < 0 then 
            iTimes[i+1] = 0            
        end

        --loop through each text
        for j = 0, 3 do 

            --flip for left most
            local t = -iTimes[i+1]
            if j < 2 then 
                t = -t
            end

            --update colors while shaking
            if iTimes[i+1] > 0.0 then 
                setShaderFloat('smashIcon'..i..'text'..j, 'doOverrideColor', 1.0)
                setShaderFloat('smashIcon'..i..'textShadow'..j, 'doOverrideColor', 1.0)

                --setShaderFloatArray('smashIcon'..i..'text'..j, 'overrideColor', {1.0, 0.0, 0.0})
                --setShaderFloatArray('smashIcon'..i..'textShadow'..j, 'overrideColor', {1.0, 0.0, 0.0})

                if iTimes[i+1] > 0.2 then 
                    setShaderFloatArray('smashIcon'..i..'text'..j, 'overrideColor', {0.73, 0.12, 0.1})
                    setShaderFloatArray('smashIcon'..i..'textShadow'..j, 'overrideColor', {0.73, 0.34, 0.32})
                elseif iTimes[i+1] > 0.15 then 
                    setShaderFloatArray('smashIcon'..i..'text'..j, 'overrideColor', {0.74, 0.72, 0.72})
                    setShaderFloatArray('smashIcon'..i..'textShadow'..j, 'overrideColor', {0.62, 0.49, 0.47})
                elseif iTimes[i+1] > 0.1 then 
                    setShaderFloatArray('smashIcon'..i..'text'..j, 'overrideColor', {0.36, 0.0, 0.0})
                    setShaderFloatArray('smashIcon'..i..'textShadow'..j, 'overrideColor', {0.62, 0.2, 0.1})
                elseif iTimes[i+1] > 0.05 then 
                    setShaderFloatArray('smashIcon'..i..'text'..j, 'overrideColor', {0.9, 0.9, 0.9})
                    setShaderFloatArray('smashIcon'..i..'textShadow'..j, 'overrideColor', {0.9, 0.9, 0.9})
                else
                    setShaderFloat('smashIcon'..i..'text'..j, 'doOverrideColor', 0.0)
                    setShaderFloat('smashIcon'..i..'textShadow'..j, 'doOverrideColor', 0.0)
                end
            else
                setShaderFloat('smashIcon'..i..'text'..j, 'doOverrideColor', 0.0)
                setShaderFloat('smashIcon'..i..'textShadow'..j, 'doOverrideColor', 0.0)
            end

            setShaderFloat('smashIcon'..i..'text'..j, 'iTime', t)
            setShaderFloat('smashIcon'..i..'textShadow'..j, 'iTime', t)
        end
    end
end


function getCharNoteType(char)
    for i = 1, #charToNoteTypeMap do
        if charToNoteTypeMap[i][1] == char then 
            return charToNoteTypeMap[i][2]
        end
    end
    return ''
end

function onEvent(tag, val1, val2)
    if tag == 'createCharacter' then
        local character = val1
        createInstance(character, "objects.Character", {0, 0, character})
        addInstance(character, true)
        table.insert(characterList, character)
    end
end

function danceCharacters()
	--play idle
    for i = 0, #characterList-1 do 
        if curBeat % getProperty(characterList[i+1]..'.danceEveryNumBeats') == 0 and not getProperty(characterList[i+1]..'.stunned') and getProperty(characterList[i+1]..'.animation.curAnim') then 
            if getProperty(characterList[i+1]..'.animation.curAnim.name') == 'idle' then 
                callMethod(characterList[i+1]..'.dance', {0})
            end
        end
    end
end

function onBeatHit()
    danceCharacters()
end

function onCountdownTick()
    danceCharacters()
end

local singAnims = {'singLEFT', 'singDOWN', 'singUP', 'singRIGHT'}

local lastHitCharacter = 'hex'
local lastOpponentHitCharacter = 'hex'

function opponentNoteHit(id, noteData, ntype, sus)
    local wasCharHit = false
    for i = 0, #characterList-1 do 
        if string.find(ntype, getCharNoteType(characterList[i+1])) then 
            --runHaxeCode('game.variables["'..characterList[i+1]..'"].playAnim("'..singAnims[getSingAnim(noteData)]..'", true);')
		    --runHaxeCode('game.variables["'..characterList[i+1]..'"].holdTimer = 0;')
            playAnim(characterList[i+1], singAnims[getMultikeyNoteIndex(noteData)+1], true)
            setProperty(characterList[i+1]..'.holdTimer', 0)
            lastOpponentHitCharacter = characterList[i+1]
            wasCharHit = true
        end
    end
end
function goodNoteHit(id, noteData, ntype, su)
    for i = 0, #characterList-1 do 
        if string.find(ntype, getCharNoteType(characterList[i+1])) then 
            playAnim(characterList[i+1], singAnims[getMultikeyNoteIndex(noteData)+1], true)
            setProperty(characterList[i+1]..'.holdTimer', 0)
            lastHitCharacter = characterList[i+1]
        end
    end
    updateSmashIcon('smashIcon3', getFormattedHealth(), 3, false)
end

function setupSmashCountdown()
    makeLuaSprite('3', 'battlefield/smash_3', 0, 0)
    setObjectCamera('3', 'hud')
    screenCenter('3')
    addLuaSprite('3', true)
    setProperty('3.alpha', 0.001)
    setProperty('3.y', getProperty('3.y') - 150)

    makeLuaSprite('2', 'battlefield/smash_2', 0, 0)
    setObjectCamera('2', 'hud')
    screenCenter('2')
    addLuaSprite('2', true)
    setProperty('2.alpha', 0.001)
    setProperty('2.y', getProperty('2.y') - 150)

    makeLuaSprite('1', 'battlefield/smash_1', 0, 0)
    setObjectCamera('1', 'hud')
    screenCenter('1')
    addLuaSprite('1', true)
    setProperty('1.alpha', 0.001)
    setProperty('1.y', getProperty('1.y') - 150)


    setProperty('3.scale.x', 0.7)
    setProperty('3.scale.y', 0.7)
    setProperty('2.scale.x', 0.8)
    setProperty('2.scale.y', 0.8)
    setProperty('1.scale.x', 0.9)
    setProperty('1.scale.y', 0.9)

    makeAnimatedLuaSprite('death', 'battlefield/Smash_Bros_Death_Explosion', -800, 200)
    scaleObject('death', 1.2, 1.2)
    addAnimationByPrefix('death', 'explode', 'Smash Bros Death Exploison instance 1', 24, false)
    setProperty('death.alpha', 0.001)
    addLuaSprite('death', true)
    setProperty('death.flipX', true)

    makeLuaSprite('gameSpr', 'battlefield/Game', 0, 0)
    setObjectCamera('gameSpr', 'hud')
    screenCenter('gameSpr')
    setProperty('gameSpr.y', getProperty('gameSpr.y') - 150)
    addLuaSprite('gameSpr', true)
    setProperty('gameSpr.alpha', 0.001)

    setProperty('gameSpr.colorTransform.redOffset', 0)
    setProperty('gameSpr.colorTransform.blueOffset', 0)
    setProperty('gameSpr.colorTransform.greenOffset', 0)

    setProperty('gameSpr.scale.x', 2.0)
    setProperty('gameSpr.scale.y', 2.0)

    --startTween("test", 'gameSpr.colorTransform', {redOffset = 255}, 1, {ease = "linear"})
end

function onStepHit()
    if curStep == 2416 then --3
        setProperty('3.alpha', 1)
        doTweenX('3scaleX', '3.scale', 0.8, crochet*0.001*4, 'linear')
        doTweenY('3scaleY', '3.scale', 0.8, crochet*0.001*4, 'linear')
    elseif curStep == 2428 then
        doTweenAlpha('3', '3', 0, crochet*0.001, 'cubeIn')
    elseif curStep == 2432 then --2
        setProperty('2.alpha', 1)
        doTweenX('2scaleX', '2.scale', 0.9, crochet*0.001*4, 'linear')
        doTweenY('2scaleY', '2.scale', 0.9, crochet*0.001*4, 'linear')
    elseif curStep == 2444 then
        doTweenAlpha('2', '2', 0, crochet*0.001, 'cubeIn')
    elseif curStep == 2448 then --1
        setProperty('1.alpha', 1)
        doTweenX('1scaleX', '1.scale', 1.0, crochet*0.001*4, 'linear')
        doTweenY('1scaleY', '1.scale', 1.0, crochet*0.001*4, 'linear')
    elseif curStep == 2460 then
        doTweenAlpha('1', '1', 0, crochet*0.001, 'cubeIn')
        

    elseif curStep == 2496 then --game
        playAnim('death', 'explode')
        setProperty('death.alpha', 1)
        setProperty('death.flipX', false)
        runTimer('hideDeathAnim', 24/24)
        setProperty('dad.visible', false)
        setProperty('miiswordfighter.visible', false)
        setProperty('miigunner.visible', false)

        --doTweenAlpha('gameSpr', 'gameSpr', 1, crochet*0.001, 'cubeIn')
        doTweenX('gameX', 'gameSpr.scale', 0.8, crochet*0.001*1, 'cubeOut')
        doTweenY('gameY', 'gameSpr.scale', 0.8, crochet*0.001*1, 'cubeOut')
        
        startTween("test", 'gameSpr.colorTransform', {redOffset = 255, greenOffset = 255, blueOffset = 255, alphaMultiplier = 1}, crochet*0.001*1, {ease = "cubeOut"})

        for i = 0, 3 do
            setProperty('smashIcon0textShadow'..i..'.alpha', 0)
            setProperty('smashIcon0text'..i..'.alpha', 0)
            setProperty('smashIcon1textShadow'..i..'.alpha', 0)
            setProperty('smashIcon1text'..i..'.alpha', 0)
            setProperty('smashIcon2textShadow'..i..'.alpha', 0)
            setProperty('smashIcon2text'..i..'.alpha', 0)
        end
        setProperty('cameraSpeed', getProperty('cameraSpeed')/2)
        setPropertyFromClass('flixel.FlxG', 'animationTimeScale', getProperty('playbackRate')/2)
    elseif curStep == 2496+4 then
        startTween("test", 'gameSpr.colorTransform', {redOffset = 0, greenOffset = 0, blueOffset = 0}, crochet*0.001*1, {ease = "linear"})
        doTweenX('gameX', 'gameSpr.scale', 0.9, crochet*0.001*4, 'linear')
        doTweenY('gameY', 'gameSpr.scale', 0.9, crochet*0.001*4, 'linear')
    elseif curStep == 2496+20 then
        startTween("test", 'gameSpr.colorTransform', {alphaMultiplier = 0}, crochet*0.001*1, {ease = "cubeIn"})
        setProperty('cameraSpeed', getProperty('cameraSpeed')*2)
        setPropertyFromClass('flixel.FlxG', 'animationTimeScale', getProperty('playbackRate'))
    end

    if curStep >= 2500-2 and curStep < 2500+4 then 
        screenCenter('gameSpr')
        setProperty('gameSpr.x', getProperty('gameSpr.x') + getRandomFloat(-25, 25))
        setProperty('gameSpr.y', getProperty('gameSpr.y') + getRandomFloat(-25, 25) - 150)
    else
        screenCenter('gameSpr')
        setProperty('gameSpr.y', getProperty('gameSpr.y') - 150)
    end


    --7 prep
    --17 throw

    if curStep == 1848-12 then
        playAnim('dad', 'prep')
        setProperty('dad.specialAnim', true)
        runTimer('brawlerThrowStart', 7/24)
        runTimer('bfHitStart', 3/24)
        playSound("battlefieldAnim1")
    end

    --bf anims

    if curStep == 1848-4 then
        
    elseif curStep == 1856+4 then 
        playAnim('death', 'explode')
        setProperty('death.alpha', 1)
        setProperty('death.flipX', true)
        runTimer('hideDeathAnim', 16/24)
        runTimer('hideBFAnims', 10/24)
        for i = 0, 3 do
            setProperty('smashIcon3textShadow'..i..'.alpha', 0)
            setProperty('smashIcon3text'..i..'.alpha', 0)
        end
    elseif curStep == 1888-8 then --respawn
        setProperty('bfAnims.alpha', 1)
        setProperty('health', 2)
        playAnim('bfAnims', 'respawn')
        runTimer('bfRespawnEnd', 17/24)
        setProperty('isCameraOnForcedPos', true)
        setProperty('camFollow.y', getProperty('camFollow.y') - 350)

        updateSmashIcon('smashIcon3', getFormattedHealth(), 3, false)
        for i = 0, 3 do
            setProperty('smashIcon3textShadow'..i..'.alpha', 1)
            setProperty('smashIcon3text'..i..'.alpha', 1)

            local offset = 300
            if not downscroll then 
                offset = -300
            end

            setProperty('smashIcon3textShadow'..i..'.y', getProperty('smashIcon3textShadow'..i..'.y') - offset)
            setProperty('smashIcon3text'..i..'.y', getProperty('smashIcon3text'..i..'.y') - offset)
            doTweenY('smashIcon3textShadow'..i..'.y', 'smashIcon3textShadow'..i, getProperty('smashIcon3textShadow'..i..'.y') + offset, 1, 'cubeOut')
            doTweenY('smashIcon3text'..i..'.y', 'smashIcon3text'..i, getProperty('smashIcon3text'..i..'.y') + offset, 1, 'cubeOut')
        end

        --53 respawn
        --17 duck

        --25 getup
    end

    if curStep == 2490 then 
        setProperty('boyfriend.alpha', 0.001)
        setProperty('bfAnims.alpha', 1)
        playAnim('bfAnims', 'prep')
        playSound("battlefieldAnim2")
    elseif curStep == 2494 then
        playAnim('bfAnims', 'attack')
    end
end

function onTimerCompleted(tag, loops, loopsLeft)

    if tag == 'brawlerThrowStart' then 
        --runTimer('bfHitStart', 2/24)
        playAnim('dad', 'throw')
        setProperty('dad.specialAnim', true)
        runTimer('brawlerThrowAgain', 16/24)
    elseif tag == 'brawlerThrowAgain' then
        playAnim('dad', 'throw', true)
        setProperty('dad.specialAnim', true)
    elseif tag == 'bfHitStart' then
        setProperty('boyfriend.alpha', 0.001)
        setProperty('bfAnims.alpha', 1)
        playAnim('bfAnims', 'hit')

        runTimer('hit1', 15/24)
        runTimer('hit2', 31/24)
    end

    if tag == 'hit1' then 
        updateSmashIcon('smashIcon3', getFormattedHealth() + 11, 3, true)
    elseif tag == 'hit2' then 
        updateSmashIcon('smashIcon3', getFormattedHealth() + 22, 3, true)
    elseif tag == 'hideDeathAnim' then
        setProperty('death.alpha', 0.001)
    elseif tag == 'hideBFAnims' then
        setProperty('bfAnims.alpha', 0.001)
    end


    if tag == 'bfRespawnEnd' then 
        playAnim('bfAnims', 'duck')
        runTimer('bfDuckEnd', 17/24)
    elseif tag == 'bfDuckEnd' then
        setProperty('platform.alpha', 1)
        playAnim('bfAnims', 'spin')
        doTweenX('bfAnimsX', 'bfAnims', getProperty('bfAnims.x')+200, 0.2, 'cubeOut')
        doTweenY('bfAnimsY', 'bfAnims', getProperty('bfAnims.y')-100, 0.2, 'cubeOut')
        setProperty('camFollow.y', getProperty('camFollow.y') + 150)
        runTimer('bfSpinDown', 0.3)
        runTimer('bfSpinEnd', 0.5)
    elseif tag == 'bfSpinDown' then
        doTweenY('bfAnimsY', 'bfAnims', getProperty('bfAnims.y')+700, 0.195, 'cubeIn')

        doTweenY('platform', 'platform', getProperty('platform.y')-1000, 0.5, 'cubeIn')
    elseif tag == 'bfSpinEnd' then 
        setProperty('bfAnims.x', getProperty('boyfriend.x'))
        setProperty('bfAnims.y', getProperty('boyfriend.y'))
        setProperty('isCameraOnForcedPos', false)
        playAnim('bfAnims', 'getup')
        runTimer('bfGetUpEnd', 20/24)
    elseif tag == 'bfGetUpEnd' then
        setProperty('boyfriend.alpha', 1)
        setProperty('bfAnims.alpha', 0.001)
    end


end