
local characterList = {}

local charToNoteTypeMap = {
    {'matt-destiny-anims', 'Darnote'},
}

function onCreatePost()
    triggerEvent('createCharacter', 'matt-destiny-anims', '')

    setObjectOrder('matt-destiny-anims', getObjectOrder('dadGroup')+1)
    setProperty('matt-destiny-anims.x', getProperty('boyfriend.x'))
    setProperty('matt-destiny-anims.y', getProperty('boyfriend.y'))
    setProperty('matt-destiny-anims.visible', false)
    --playAnim('matt-destiny-anims', 'intro', true)
end

function onEvent(tag, val1, val2)
    if tag == 'createCharacter' then
        local character = val1
        createInstance(character, "objects.Character", {0, 0, character, true})
        addInstance(character, true)
        table.insert(characterList, character)
    end
end

function onStepHit()

    if curStep == 1456 then 
        setProperty('matt-destiny-anims.visible', true)
        setProperty('matt-destiny-anims.x', 530)
        setProperty('matt-destiny-anims.y', -30)
        playAnim('matt-destiny-anims', 'intro', true)
    elseif curStep == 1988 then 
        triggerEvent('Play Animation', 'crys', 'dad')
    elseif curStep == 2008 then 
        setProperty('matt-destiny-anims.visible', true)
        setProperty('boyfriend.visible', false)
        playAnim('matt-destiny-anims', 'end', true)
    elseif curStep == 2112 then 
        playAnim('matt-destiny-anims', 'punch', true)
    end
end

function onGameOver()
    setPropertyFromClass('substates.GameOverSubstate', 'characterName', '');
end
function onGameOverStart()
    runTimer('restart', 1.5)
end

function onTimerCompleted(tag, l, left)
    if tag == 'restart' then 
        restartSong()
    end
end