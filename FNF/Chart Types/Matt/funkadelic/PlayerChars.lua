local characterList = {}

local charToNoteTypeMap = {
    {'piico', 'Darnote1'},
    {'darnellmii_player', 'Darnote2'},
    {'skarlet', 'Darnote3'},
    {'redshaggy', 'Darnote4'},
    {'matt-player', 'Darnote5'},
}

local defaultX = 0
local defaultY = 0

function onCreatePost()
    luaDebugMode = true
    triggerEvent('createCharacter', 'piico', '')
    triggerEvent('createCharacter', 'darnellmii_player', '')
    triggerEvent('createCharacter', 'skarlet', '')
    triggerEvent('createCharacter', 'redshaggy', '')
    triggerEvent('createCharacter', 'matt-player', '')

    defaultX = getProperty('boyfriend.x')
    defaultY = getProperty('boyfriend.y')

    setProperty('piico.x', defaultX-300)
    setProperty('piico.y', defaultY+50)
    setProperty('piico.flipX', false)
    setProperty('darnellmii_player.x', defaultX+200)
    setProperty('darnellmii_player.y', defaultY+70)
    setProperty('darnellmii_player.flipX', true)
    setProperty('skarlet.x', defaultX)
    setProperty('skarlet.y', defaultY)
    setProperty('skarlet.flipX', true)
    setProperty('redshaggy.x', defaultX+200)
    setProperty('redshaggy.y', defaultY+50)
    setProperty('redshaggy.flipX', true)
    setProperty('matt-player.x', defaultX-200)
    setProperty('matt-player.y', defaultY-300)
    setProperty('matt-player.flipX', true)

    --setProperty('dad.x', getProperty('dad.x')+25)
    setProperty('piico.alpha', 0.001)
    setProperty('darnellmii_player.alpha', 0.001)
    setProperty('skarlet.alpha', 0.001)
    setProperty('redshaggy.alpha', 0.001)
    setProperty('matt-player.alpha', 0.001)

    setObjectOrder('piico', getObjectOrder('boyfriendGroup')+1)
    setObjectOrder('darnellmii_player', getObjectOrder('boyfriendGroup')+1)
    setObjectOrder('skarlet', getObjectOrder('boyfriendGroup')+1)
    setObjectOrder('redshaggy', getObjectOrder('boyfriendGroup')-1)
    setObjectOrder('matt-player', getObjectOrder('boyfriendGroup')-1)

    for i = 0, getProperty('unspawnNotes.length')-1 do
        for j = 0, #characterList-1 do
            if string.find(getPropertyFromGroup('unspawnNotes', i, 'noteType'), getCharNoteType(characterList[j+1])) 
                and not string.find(getPropertyFromGroup('unspawnNotes', i, 'noteType'), "-duet") then 
                setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
            end
        end
    end

    generateIcon('iconP3', getProperty('piico.healthIcon'), true)
    generateIcon('iconP4', getProperty('darnellmii_player.healthIcon'), true)
    generateIcon('iconP5', getProperty('skarlet.healthIcon'), true)
    generateIcon('iconP6', getProperty('matt-player.healthIcon'), true)
    generateIcon('iconP7', getProperty('redshaggy.healthIcon'), true)

    setProperty('iconP3.alpha', 0.001)
    setProperty('iconP4.alpha', 0.001)
    setProperty('iconP5.alpha', 0.001)
    setProperty('iconP6.alpha', 0.001)
    setProperty('iconP7.alpha', 0.001)

    setProperty('iconP3.x', getProperty('iconP1.x')-50)
    setProperty('iconP3.y', getProperty('iconP1.y')+40)
    setProperty('iconP4.x', getProperty('iconP1.x')+50)
    setProperty('iconP4.y', getProperty('iconP1.y')+40)
    setProperty('iconP5.x', getProperty('iconP1.x'))
    setProperty('iconP5.y', getProperty('iconP1.y')+40)
    setProperty('iconP6.x', getProperty('iconP1.x')-50)
    setProperty('iconP6.y', getProperty('iconP1.y')-40)
    setProperty('iconP7.x', getProperty('iconP1.x')+50)
    setProperty('iconP7.y', getProperty('iconP1.y')-40)

    --setProperty('iconP3.alpha', getProperty('iconP2.alpha'))
    setProperty('iconP3.visible', getProperty('iconP2.visible'))
    setProperty('iconP4.visible', getProperty('iconP2.visible'))
    setProperty('iconP5.visible', getProperty('iconP2.visible'))
    setProperty('iconP6.visible', getProperty('iconP2.visible'))
    setProperty('iconP7.visible', getProperty('iconP2.visible'))
end

function onUpdatePost(elapsed)
    if inGameOver then 
        return
    end
    setProperty('iconP3.scale.x', getProperty('iconP1.scale.x')-0.25)
    setProperty('iconP3.scale.y', getProperty('iconP1.scale.y')-0.25)
    updateHitbox('iconP3')

    setProperty('iconP4.scale.x', getProperty('iconP1.scale.x')-0.25)
    setProperty('iconP4.scale.y', getProperty('iconP1.scale.y')-0.25)
    updateHitbox('iconP4')
    
    setProperty('iconP5.scale.x', getProperty('iconP1.scale.x')-0.25)
    setProperty('iconP5.scale.y', getProperty('iconP1.scale.y')-0.25)
    updateHitbox('iconP5')

    setProperty('iconP6.scale.x', getProperty('iconP1.scale.x')-0.25)
    setProperty('iconP6.scale.y', getProperty('iconP1.scale.y')-0.25)
    updateHitbox('iconP6')

    setProperty('iconP7.scale.x', getProperty('iconP1.scale.x')-0.25)
    setProperty('iconP7.scale.y', getProperty('iconP1.scale.y')-0.25)
    updateHitbox('iconP7')

    setProperty('iconP3.animation.curAnim.curFrame', getProperty('iconP1.animation.curAnim.curFrame'))
    setProperty('iconP4.animation.curAnim.curFrame', getProperty('iconP1.animation.curAnim.curFrame'))
    setProperty('iconP5.animation.curAnim.curFrame', getProperty('iconP1.animation.curAnim.curFrame'))
    setProperty('iconP6.animation.curAnim.curFrame', getProperty('iconP1.animation.curAnim.curFrame'))
    setProperty('iconP7.animation.curAnim.curFrame', getProperty('iconP1.animation.curAnim.curFrame'))
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

function generateIcon(name, icon, isPlayer)
    createInstance(name, "objects.HealthIcon", {icon, isPlayer})
    callMethod('uiGroup.add', {instanceArg(name)})
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
        playAnim(characterList[i+1], singAnims[getMultikeyNoteIndex(noteData)+1], true)
        setProperty(characterList[i+1]..'.holdTimer', 0)
        lastHitCharacter = characterList[i+1]
    end
end


function onStepHit()
    if curStep == 1312 then 
        doTweenAlpha('piico-tween', 'piico', 0.5, 0.5, 'cubeOut')

        doTweenAlpha('piicoIcon', 'iconP3', 0.5 * getProperty('iconP2.alpha'), 0.5, 'cubeOut')

    elseif curStep == 1344 then 
        doTweenAlpha('piico-tween', 'piico', 0.001, 0.5, 'cubeOut')
        
        doTweenAlpha('piicoIcon', 'iconP3', 0.001, 0.5, 'cubeOut')

    elseif curStep == 1376 then 
        doTweenAlpha('piico-tween', 'piico', 0.5, 0.5, 'cubeOut')

        doTweenAlpha('piicoIcon', 'iconP3', 0.5 * getProperty('iconP2.alpha'), 0.5, 'cubeOut')
        
    elseif curStep == 1408 then 
        doTweenAlpha('piico-tween', 'piico', 0.001, 0.5, 'cubeOut')

        doTweenAlpha('piicoIcon', 'iconP3', 0.001, 0.5, 'cubeOut')

    elseif curStep == 1472 then 
        doTweenAlpha('darnell-tween', 'darnellmii_player', 0.5, 0.5, 'cubeOut')

        doTweenAlpha('darnellIcon', 'iconP4', 0.5 * getProperty('iconP2.alpha'), 0.5, 'cubeOut')
        
    elseif curStep == 1536 then 
        doTweenAlpha('darnell-tween', 'darnellmii_player', 0.001, 0.5, 'cubeOut')

        doTweenAlpha('darnellIcon', 'iconP4', 0.001, 0.5, 'cubeOut')

    elseif curStep == 1600 then 
        doTweenAlpha('skarlet-tween', 'skarlet', 0.5, 0.5, 'cubeOut')

        doTweenAlpha('skarletIcon', 'iconP5', 0.5 * getProperty('iconP2.alpha'), 0.5, 'cubeOut')
        
    elseif curStep == 1664 then 
        doTweenAlpha('skarlet-tween', 'skarlet', 0.001, 0.5, 'cubeOut')

        doTweenAlpha('skarletIcon', 'iconP5', 0.001, 0.5, 'cubeOut')

    elseif curStep == 1952 then 
        doTweenAlpha('matt-tween', 'matt-player', 0.5, 0.5, 'cubeOut')

        doTweenAlpha('mattIcon', 'iconP6', 0.5 * getProperty('iconP2.alpha'), 0.5, 'cubeOut')

    elseif curStep == 2032 then 
        doTweenAlpha('matt-tween', 'matt-player', 0.001, 2.75, 'cubeOut')
        
        doTweenAlpha('mattIcon', 'iconP6', 0.001, 2.75, 'cubeOut')

    elseif curStep == 2080 then 
        doTweenAlpha('shag-tween', 'redshaggy', 0.5, 0.5, 'cubeOut')

        doTweenAlpha('shagIcon', 'iconP7', 0.5 * getProperty('iconP2.alpha'), 0.5, 'cubeOut')

    elseif curStep == 2146 then
        doTweenAlpha('shag-tween', 'redshaggy', 0.001, 0.5, 'cubeOut')
        doTweenAlpha('matt-tween', 'matt-player', 0.5, 0.5, 'cubeOut')

        doTweenAlpha('shagIcon', 'iconP7', 0.001, 0.5, 'cubeOut')
        doTweenAlpha('mattIcon', 'iconP6', 0.5 * getProperty('iconP2.alpha'), 0.5, 'cubeOut')

    elseif curStep == 2208 then
        doTweenAlpha('matt-tween', 'matt-player', 0.001, 0.5, 'cubeOut')

        doTweenAlpha('mattIcon', 'iconP6', 0.001, 0.5, 'cubeOut')

    end
end