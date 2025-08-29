local beatsScaleX = {18,21.5,23,26,29.5}
local beatsScaleY = {16,19.5,20.5,22.5,24,27.5,28.5}
function onCreatePost()
    --luaDebugMode = true
    addHaxeLibrary('playfieldRenderer', 'modcharting')
    addHaxeLibrary('Vector3D', 'openfl.geom')
    addHaxeLibrary('Math')

    startMod('xP2', 'XModifier', 'opponent', -1)
    startMod('xP1', 'XModifier', 'player', -1)
    
    startMod('boost', 'BoostModifier', '', -1)
    startMod('brake', 'BrakeModifier', '', -1)

    startMod('speed', 'SpeedModifier', '', -1)

    startMod('tipsy', 'TipsyYModifier', '', -1)
    startMod('drunkP1', 'DrunkXModifier', 'player', -1)
    startMod('drunkP2', 'DrunkXModifier', 'opponent', -1)

    startMod('beatYP1', 'BeatYModifier', 'player', -1)
    startMod('beatYP2', 'BeatYModifier', 'opponent', -1)

    startMod('beat', 'BeatXModifier', 'player', -1)

    startMod('reverseP2', 'ReverseModifier', 'opponent', -1)
    startMod('reverseP1', 'ReverseModifier', 'player', -1)

    startMod('incomingAngle', 'IncomingAngleModifier', '', -1)
    setSubMod('incomingAngle', 'x', 90)
    startMod('InvertIncomingAnglee', 'InvertIncomingAngle', '', -1)

    startMod('flip', 'FlipModifier', '', -1)
    startMod('invert', 'InvertModifier', '', -1)

    startMod('alpha', 'StealthModifier', '', -1)

    startMod('opponentAlpha', 'StealthModifier', 'opponent', -1)

    startMod('scaleX', 'ScaleXModifier', '', -1)
    startMod('scaleY', 'ScaleYModifier', '', -1)
    startMod('drunk', 'DrunkXModifier', '', -1)
    setSubMod('drunk', 'speed', 10)

    startMod('MoveYWaveShitt', 'MoveYWaveShit', '', -1)
	
    ease(31, 1, 'cubeInOut', [[
        0, brake,
        0.75, speed,
        1.5, beatYP1,
        -1.5, beatYP2,
        -300, z,
    ]])

    ease(64, 1, 'cubeInOut', [[
        -320, xP1,
        320, xP2,
        1, reverseP2,
        0.7, opponentAlpha
    ]])


    for i = 8,23 do 
        if i >= 16 then 
            if i % 2 == 1 then 
                ease(i*4, 4, 'circInOut', [[
                    30, incomingAngle:x,
                    100, z0,
                    50, z1,
                    -50, z2,
                    -100, z3,
                    100, z4,
                    50, z5,
                    -50, z6,
                    -100, z7,
                ]])
            else 
                ease(i*4, 4, 'circInOut', [[
                    -30, incomingAngle:x,
                    -100, z0,
                    -50, z1,
                    50, z2,
                    100, z3,
                    -100, z4,
                    -50, z5,
                    50, z6,
                    100, z7,
                ]])
            end
        end
        if i % 2 == 1 then 
            ease((i*4)+3, 1, 'circIn', [[
                0, confusion
            ]])
        else 
            ease(i*4, 1, 'circOut', [[
                360, confusion
            ]])
        end
    end

    for i = 24,31 do 
        if i % 2 == 1 then 
            ease(i*4, 4, 'circInOut', [[
                15, incomingAngle:x,
                50, z0,
                25, z1,
                -25, z2,
                -50, z3,
                50, z4,
                25, z5,
                -25, z6,
                -50, z7,
            ]])

            ease(i*4, 2, 'cubeInOut', [[
                0, reverseP1,
                1, reverseP2
            ]])
        else 
            ease(i*4, 4, 'circInOut', [[
                -15, incomingAngle:x,
                -50, z0,
                -25, z1,
                25, z2,
                50, z3,
                -50, z4,
                -25, z5,
                25, z6,
                50, z7,
            ]])

            ease((i*4), 2, 'cubeInOut', [[
                1, reverseP1,
                0, reverseP2
            ]])
        end

        if (i % 4 ~= 3) then
            ease((i*4)+1.5, 1, 'circInOut', [[
                -360, confusion
            ]])
        else 
            ease(i*4, 1, 'circOut', [[
                360, confusion
            ]])
            ease((i*4)+3, 1, 'circIn', [[
                0, confusion
            ]])
        end

    end

    ease(128, 1, 'cubeInOut', [[
        0, z0,
        0, z1,
        0, z2,
        0, z3,
        -600, z4,
        -600, z5,
        -600, z6,
        -600, z7,
        0, reverseP1,
        0, reverseP2,
        0, InvertIncomingAnglee,
        90, incomingAngle:x,
        0, IncomingAngleSmooth,
        0, beatYP1,
        0, beatYP2,
        -200, z,
        1, boost,
        -100, x0,
        -50, x1,
        50, x2,
        100, x3,
        -100, x4,
        -50, x5,
        50, x6,
        100, x7,
        360, confusion,
    ]])

    ease(158, 1, 'cubeInOut', [[
        -600, z0,
        -600, z1,
        -600, z2,
        -600, z3,
        0, z4,
        0, z5,
        0, z6,
        0, z7,
        -360, confusion
    ]])

    ease(191, 1, 'cubeInOut', [[
        0, z0,
        0, z1,
        0, z2,
        0, z3,
        -600, z4,
        -600, z5,
        -600, z6,
        -600, z7,
        360, confusion,
    ]])

    ease(207, 1, 'cubeInOut', [[
        -600, z0,
        -600, z1,
        -600, z2,
        -600, z3,
        0, z4,
        0, z5,
        0, z6,
        0, z7,
        -360, confusion
    ]])

    ease(250, 1, 'cubeInOut', [[
        0, z0,
        0, z1,
        0, z2,
        0, z3,
        0, z4,
        0, z5,
        0, z6,
        0, z7,
        0, tipsy,
        0, drunkP1,
        0, drunkP2,
        0, flip,
        0, boost,
		0, confusion,
        1, opponentAlpha,
    ]])
    
    --[[
        0, x0,
        0, x1,
        0, x2,
        0, x3,
        0, x4,
        0, x5,
        0, x6,
        0, x7,
    ]]

    if downscroll then 

        ease(256, 1, 'cubeInOut', [[
            0.7, speed,
            -60, y,
        ]])
    else 
        
		ease(256, 1, 'cubeInOut', [[
			0.7, speed,
			60, y,
		]])
    end



    for i = 0,7 do
        local beat = 256+(8*i)
        ease(beat+2, 2, 'backInOut', [[
            -360, confusion,
        ]])
        ease(beat+6, 2, 'backInOut', [[
            360, confusion,
        ]])
    end

    if downscroll then 
		ease(288, 31, 'linear', [[
			-720, incomingAngle:y,
			-720, confusion,
			-460, y,
		]])
	else
		ease(288, 31, 'linear', [[
				-720, incomingAngle:y,
				-720, confusion,
				460, y,
			]])
	end

	if downscroll then 
		ease(320, 16, 'linear', [[
			720, incomingAngle:y,
			720, confusion,
			-60, y,
		]])
	else
		ease(320, 16, 'linear', [[
				720, incomingAngle:y,
				720, confusion,
				60, y,
			]])
	end
	if downscroll then 
		ease(336, 16, 'linear', [[
			-720, incomingAngle:y,
			-720, confusion,
			-460, y,
		]])
	else
		ease(336, 16, 'linear', [[
				-720, incomingAngle:y,
				-720, confusion,
				460, y,
			]])
	end

	if downscroll then
    ease(352, 1, 'cubeInOut', [[
        0.7, speed,
		-260, y,
        0, z,
        90, incomingAngle:y,
        1, MoveYWaveShitt,
        0, beatYP1,
        0, beatYP2,
        1, opponentAlpha,
        1.6, speed,
        1.5, beat,
    ]])
	
	else
	
	ease(352, 1, 'cubeInOut', [[
        0.7, speed,
		260, y,
        0, z,
        90, incomingAngle:y,
        1, MoveYWaveShitt,
        0, beatYP1,
        0, beatYP2,
        1, opponentAlpha,
        1.6, speed,
        1.5, beat,
    ]])
	
	end

	set(384, [[
		1, speed,
		0, y,
        0, z,
        0, incomingAngle:y,
        0, MoveYWaveShitt,
        0, beatYP1,
        0, beatYP2,
        1, opponentAlpha,
        0, beat,
		0, tipsy,
        0, drunkP1,
        0, drunkP2,
        0, x0,
        0, x1,
        0, x2,
        0, x3,
        0, x4,
        0, x5,
        0, x6,
        0, x7
	]])


    if downscroll then 

        ease(447, 1, 'cubeInOut', [[
            0.7, speed,
            -60, y,
			-100, x0,
			-50, x1,
			50, x2,
			100, x3,
			-100, x4,
			-50, x5,
			50, x6,
			100, x7,
        ]])
    else 
        
		ease(447, 1, 'cubeInOut', [[
			0.7, speed,
			60, y,
			-100, x0,
			-50, x1,
			50, x2,
			100, x3,
			-100, x4,
			-50, x5,
			50, x6,
			100, x7,
		]])
    end



    for i = 0,7 do
        local beat = 477+(8*i)
        ease(beat+2, 2, 'backInOut', [[
            -360, confusion,
        ]])
        ease(beat+6, 2, 'backInOut', [[
            360, confusion,
        ]])
    end

    if downscroll then 
		ease(448, 16, 'linear', [[
			-720, incomingAngle:y,
			-720, confusion,
			-460, y,
            -300, z,
		]])
	else
		ease(448, 16, 'linear', [[
            -720, incomingAngle:y,
            -720, confusion,
            460, y,
            -300, z,
        ]])
	end

	if downscroll then 
		ease(464, 16, 'linear', [[
			0, incomingAngle:y,
			0, confusion,
			-60, y,
		]])
	else
		ease(464, 16, 'linear', [[
				0, incomingAngle:y,
				0, confusion,
				60, y,
			]])
	end
	if downscroll then 
		ease(480, 16, 'linear', [[
			-720, incomingAngle:y,
			-720, confusion,
			-460, y,
		]])
	else
		ease(480, 16, 'linear', [[
				-720, incomingAngle:y,
				-720, confusion,
				460, y,
			]])
	end
	if downscroll then 
		ease(496, 16, 'linear', [[
			0, incomingAngle:y,
			0, confusion,
			-60, y,
		]])
	else
		ease(496, 16, 'linear', [[
				0, incomingAngle:y,
				0, confusion,
				60, y,
			]])
	end

    for i = 4, 11 do 
        setupBeatShit(i)
    end
	setupBigBeatShit(12)
	setupBigBeatShit(13)
	setupBiggerBeatShit(14)
	setupBiggerBeatShit(15)
	for i = 16, 31 do
		setupBeatShit(i)
    end
    for i = 104, 128 do 
        setupBeatShit(i)
    end
end

function setupBeatShit(i)
    local beat = (i*4)
    set(beat-0.001, [[
        1.5, scaleY
    ]])
    ease(beat, 0.5, 'cubeOut', [[
        1, scaleY
    ]])
    set(beat-0.001+0.5, [[
        1.5, scaleY
    ]])
    ease(beat+0.5, 0.5, 'cubeOut', [[
        1, scaleY
    ]])
    set(beat-0.001+1, [[
        1.5, scaleX,
        2, drunk
    ]])
    ease(beat+1, 0.5, 'cubeOut', [[
        1, scaleX,
        0, drunk
    ]])
	set(beat-0.001+0.5+1, [[
        1.5, scaleY
    ]])
    ease(beat+0.5+1, 0.5, 'cubeOut', [[
        1, scaleY
    ]])
    set(beat-0.001+2, [[
        1.5, scaleX
    ]])
    ease(beat+2, 0.5, 'cubeOut', [[
        1, scaleX
    ]])
    set(beat-0.001+0.5+2, [[
        1.5, scaleY
    ]])
    ease(beat+0.5+2, 0.5, 'cubeOut', [[
        1, scaleY
    ]])
    set(beat-0.001+1+2, [[
        1.5, scaleX,
        2, drunk
    ]])
    ease(beat+1+2, 0.5, 'cubeOut', [[
        1, scaleX,
        0, drunk
    ]])
end


function setupBigBeatShit(i)
    local beat = (i*4)
    set(beat-0.001, [[
        1.5, scaleY,
        2, drunk
    ]])
    ease(beat, 0.5, 'cubeOut', [[
        1, scaleY,
        0, drunk
    ]])
    set(beat-0.001+0.5, [[
        1.5, scaleY
    ]])
    ease(beat+0.5, 0.5, 'cubeOut', [[
        1, scaleY
    ]])
    set(beat-0.001+1, [[
        1.5, scaleX,
        2, drunk
    ]])
    ease(beat+1, 0.5, 'cubeOut', [[
        1, scaleX,
        0, drunk
    ]])
	set(beat-0.001+0.5+1, [[
        1.5, scaleY
    ]])
    ease(beat+0.5+1, 0.5, 'cubeOut', [[
        1, scaleY
    ]])
    set(beat-0.001+2, [[
        1.5, scaleX,
        2, drunk
    ]])
    ease(beat+2, 0.5, 'cubeOut', [[
        1, scaleX,
        0, drunk
    ]])
    set(beat-0.001+0.5+2, [[
        1.5, scaleY
    ]])
    ease(beat+0.5+2, 0.5, 'cubeOut', [[
        1, scaleY
    ]])
    set(beat-0.001+1+2, [[
        1.5, scaleX,
        2, drunk
    ]])
    ease(beat+1+2, 0.5, 'cubeOut', [[
        1, scaleX,
        0, drunk
    ]])
end


function setupBiggerBeatShit(i)
    local beat = (i*4)
    set(beat-0.001, [[
        1.5, scaleY,
        2, drunk
    ]])
    ease(beat, 0.5, 'cubeOut', [[
        1, scaleY,
        0, drunk
    ]])
    set(beat-0.001+0.5, [[
        1.5, scaleY,
        2, drunk
    ]])
    ease(beat+0.5, 0.5, 'cubeOut', [[
        1, scaleY,
        0, drunk
    ]])
    set(beat-0.001+1, [[
        1.5, scaleX,
        2, drunk
    ]])
    ease(beat+1, 0.5, 'cubeOut', [[
        1, scaleX,
        0, drunk
    ]])
	set(beat-0.001+0.5+1, [[
        1.5, scaleY,
        2, drunk
    ]])
    ease(beat+0.5+1, 0.5, 'cubeOut', [[
        1, scaleY,
        0, drunk
    ]])
    set(beat-0.001+2, [[
        1.5, scaleX,
        2, drunk
    ]])
    ease(beat+2, 0.5, 'cubeOut', [[
        1, scaleX,
        0, drunk
    ]])
    set(beat-0.001+0.5+2, [[
        1.5, scaleY,
        2, drunk
    ]])
    ease(beat+0.5+2, 0.5, 'cubeOut', [[
        1, scaleY,
        0, drunk
    ]])
    set(beat-0.001+1+2, [[
        1.5, scaleX,
        2, drunk
    ]])
    ease(beat+1+2, 0.5, 'cubeOut', [[
        1, scaleX,
        0, drunk
    ]])
end