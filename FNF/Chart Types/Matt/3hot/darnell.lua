--simplified version of my old char script  -Teniente Mantequilla --
local theDefaultGameAnimations = {'singLEFT', 'singDOWN', 'singUP', 'singRIGHT', 'idle'}
local darnollanims = {'DARNELLleft', 'DARNELLdown', 'DARNELLup', 'DARNELLright', 'DARNELLidle'}
local offset = {85, 30, 45, 46, 60, 9, -20, 98, 32, 50}
local darsing = true
local darhold = 0

function onCreate()
	makeAnimatedLuaSprite('darnell', 'characters/darnellmii', -120, 425)
	for i = 1, 5 do
		addAnimationByPrefix('darnell', theDefaultGameAnimations[i], darnollanims[i], 24, false)
	end
	addLuaSprite('darnell', false)
	setObjectOrder('darnell', getObjectOrder('dadGroup')-1)
	objectPlayAnimation('darnell', 'idle')
	setProperty('darnell.offset.x', offset[5])
	setProperty('darnell.offset.y', offset[10])
	
	for i = 0, getProperty('unspawnNotes.length')-1 do
        if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true);
        end
	end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if darsing then
		darhold = stepCrochet * 0.004
		objectPlayAnimation('darnell', theDefaultGameAnimations[direction + 1], true)
		setProperty('darnell.offset.x', offset[direction + 1])
		setProperty('darnell.offset.y', offset[direction + 6])
	else 
		characterPlayAnim('dad', theDefaultGameAnimations[direction+1], true)
		setProperty('dad.holdTimer', 0)
	end
end

function onBeatHit()
	if darhold <= 0 then
		objectPlayAnimation('darnell', 'idle')
		setProperty('darnell.offset.x', offset[5])
		setProperty('darnell.offset.y', offset[10])
	end

end

function onUpdate(elapsed)
	darhold = darhold - elapsed
end

function onEvent(name, value1, value2)
	if name == 'darnoll' then
		darsing = not darsing
	end
end
