local characterList = {}

local charToNoteTypeMap = {
    {'bluematt', 'Darnote'},
}

function onCreatePost()
    triggerEvent('createCharacter', 'bluematt', '')

    setProperty('dad.y', getProperty('dad.y')-60)
    setProperty('dad.x', getProperty('dad.x')+80)
    setSpriteShader('bluematt', 'lightingEffects')

    setObjectOrder('bluematt', getObjectOrder('dadGroup')+1)

    for i = 0, getProperty('unspawnNotes.length')-1 do
        for j = 0, #characterList-1 do
            if string.find(getPropertyFromGroup('unspawnNotes', i, 'noteType'), getCharNoteType(characterList[j+1])) 
                and not string.find(getPropertyFromGroup('unspawnNotes', i, 'noteType'), "-duet") then 
                setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
            end
        end
    end

    generateIcon('iconP3', getProperty('bluematt.healthIcon'), false)
    setProperty('iconP2.x', getProperty('iconP2.x')-25)
    setProperty('iconP2.y', getProperty('iconP2.y')-25)
    setProperty('iconP3.x', getProperty('iconP2.x')+50)
    setProperty('iconP3.y', getProperty('iconP2.y')+50)

    setProperty('iconP3.alpha', getProperty('iconP2.alpha'))
    setProperty('iconP3.visible', getProperty('iconP2.visible'))

    --callMethod('iconP2.changeIcon', {"icon-mattxbmatt"})
    local camOffset = getProperty('opponentCameraOffset')
    camOffset[2] = camOffset[2] + 0
    setProperty('opponentCameraOffset', camOffset)
end

function generateIcon(name, icon, isPlayer)
    createInstance(name, "objects.HealthIcon", {icon, isPlayer})
    callMethod('uiGroup.insert', {5, instanceArg(name)})
end

function onUpdatePost()
    setProperty('bluematt.x', getProperty('dad.x')-130)
    setProperty('bluematt.y', getProperty('dad.y')+60)

    setProperty('iconP3.animation.curAnim.curFrame', getProperty('iconP2.animation.curAnim.curFrame'))
    setProperty('iconP3.scale.x', getProperty('iconP2.scale.x'))
    setProperty('iconP3.scale.y', getProperty('iconP2.scale.y'))
    updateHitbox('iconP3')
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
    for i = 0, #characterList-1 do 
        if string.find(ntype, getCharNoteType(characterList[i+1])) then 
            --runHaxeCode('game.variables["'..characterList[i+1]..'"].playAnim("'..singAnims[getSingAnim(noteData)]..'", true);')
		    --runHaxeCode('game.variables["'..characterList[i+1]..'"].holdTimer = 0;')
            playAnim(characterList[i+1], singAnims[getMultikeyNoteIndex(noteData)+1], true)
            setProperty(characterList[i+1]..'.holdTimer', 0)
            lastOpponentHitCharacter = characterList[i+1]
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