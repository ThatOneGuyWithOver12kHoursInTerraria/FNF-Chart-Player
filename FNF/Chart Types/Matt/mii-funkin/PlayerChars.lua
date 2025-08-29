local characterList = {}

local charToNoteTypeMap = {
    {'spongemii', 'Darnote1'},
    {'burg', 'Darnote2'},
}

local defaultX = 0
local defaultY = 0

local icons = {}

function onCreatePost()
    luaDebugMode = true
    triggerEvent('createCharacter', 'spongemii', '')
    triggerEvent('createCharacter', 'burg', '')

    defaultX = getProperty('dad.x')
    defaultY = getProperty('dad.y')

    setProperty('spongemii.x', defaultX)
    setProperty('spongemii.y', defaultY)
    setProperty('burg.x', defaultX)
    setProperty('burg.y', defaultY+250)

    --setProperty('dad.x', getProperty('dad.x')+25)
    setProperty('spongemii.alpha', 0.001)
    setProperty('burg.alpha', 0.001)

    setObjectOrder('spongemii', getObjectOrder('dadGroup')-1)
    setObjectOrder('burg', getObjectOrder('dadGroup')-1)

    for i = 0, getProperty('unspawnNotes.length')-1 do
        for j = 0, #characterList-1 do
            if string.find(getPropertyFromGroup('unspawnNotes', i, 'noteType'), getCharNoteType(characterList[j+1])) 
                and not string.find(getPropertyFromGroup('unspawnNotes', i, 'noteType'), "-duet") then 
                setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
            end
        end
    end

    generateIcon('iconP3', getProperty('spongemii.healthIcon'), false)
    generateIcon('iconP4', getProperty('burg.healthIcon'), false)
    setProperty('iconP3.visible', false)
    setProperty('iconP3.alpha', getProperty('iconP2.alpha'))
    setProperty('iconP4.visible', false)
    setProperty('iconP4.alpha', getProperty('iconP2.alpha'))


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

function onUpdatePost(elapsed)
    setProperty('iconP3.scale.x', getProperty('iconP2.scale.x'))
    setProperty('iconP3.scale.y', getProperty('iconP2.scale.y'))
    updateHitbox('iconP3')

    setProperty('iconP4.scale.x', getProperty('iconP2.scale.x'))
    setProperty('iconP4.scale.y', getProperty('iconP2.scale.y'))
    updateHitbox('iconP4')

    setProperty('iconP3.animation.curAnim.curFrame', getProperty('iconP2.animation.curAnim.curFrame'))
    setProperty('iconP4.animation.curAnim.curFrame', getProperty('iconP2.animation.curAnim.curFrame'))
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
end


function onStepHit()
    if curStep == 384 then 
        local camOffset = getProperty('opponentCameraOffset')
        camOffset[1] = camOffset[1] + 350
        camOffset[2] = camOffset[2] + 40
        setProperty('opponentCameraOffset', camOffset)

        setProperty('dad.x', defaultX - 350)
        setProperty('dad.y', defaultY - 40)
        setProperty('spongemii.alpha', 1)
        setObjectOrder('spongemii', getObjectOrder('dadGroup')+1)

        callMethod('iconP2.changeIcon', {getProperty('spongemii.healthIcon')})

    elseif curStep == 768 then

        setProperty('spongemii.x', defaultX - 150)
        setProperty('spongemii.y', defaultY - 100)
        setObjectOrder('spongemii', getObjectOrder('dadGroup')-1)

        setProperty('burg.alpha', 1)
        setObjectOrder('burg', getObjectOrder('dadGroup')+1)

        callMethod('iconP2.changeIcon', {getProperty('burg.healthIcon')})

    elseif curStep == 897 then 

        setProperty('dad.x', defaultX + 50)
        setProperty('dad.y', defaultY)
        local camOffset = getProperty('opponentCameraOffset')
        camOffset[1] = camOffset[1] - 350
        camOffset[2] = camOffset[2] - 40
        camOffset[1] = camOffset[1] - 100
        setProperty('opponentCameraOffset', camOffset)


        setProperty('spongemii.x', defaultX - 220)
        setProperty('spongemii.y', defaultY - 80)
        setProperty('burg.x', defaultX - 530)
        setProperty('burg.y', defaultY + 250)

        setObjectOrder('spongemii', getObjectOrder('dadGroup')-1)
        setObjectOrder('burg', getObjectOrder('dadGroup')+1)

        setProperty('iconP3.visible', getProperty('iconP2.visible'))
        setProperty('iconP4.visible', getProperty('iconP2.visible'))

        setProperty('iconP3.x', getProperty('iconP2.x')-20)
        setProperty('iconP3.y', getProperty('iconP2.y')-20)
        setProperty('iconP4.x', getProperty('iconP2.x')-50)
        setProperty('iconP4.y', getProperty('iconP2.y')+20)
    
        setProperty('iconP2.x', getProperty('iconP2.x')+30)
        setProperty('iconP2.y', getProperty('iconP2.y'))

        callMethod('iconP2.changeIcon', {getProperty('dad.healthIcon')})

        local mattCamOffset = getProperty('boyfriendCameraOffset')
        mattCamOffset[1] = mattCamOffset[1] - 200
        setProperty('boyfriendCameraOffset', mattCamOffset)
    end
end