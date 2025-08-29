--CREDITS:
--Base script by TheZoroForce240
--Events by RhysRJJ

--important funcs needed
function initShader(shaderName, shaderPath, values, defaultValues)
    callScript("shaders", "initShader", {shaderName, shaderPath, values, defaultValues})
end
function setCameraShader(cam, shaderName)
    callScript("shaders", "setCameraShader", {cam, shaderName})
end
function setShaderProperty(shaderName, variable, value)
    setProperty(shaderName..variable..'.x', value)
end
function getShaderProperty(shaderName, variable)
    getProperty(shaderName..variable..'.x')
end
function tweenShaderProperty(shaderName, variable, value, time, ease)
    doTweenX(shaderName..variable, shaderName..variable, value, time, ease)
end

function onCreatePost()
    luaDebugMode = true
    addLuaScript('shaders')

    initShader('heat', 'HeatShader', {'strength', 'iTime'}, {0.7, 0})
    setCameraShader('game', 'heat')
    setCameraShader('hud', 'heat')

    --Mirror Repeat, this one is used for zooms and shit mainly
    initShader('mirror', 'mirrorRepeat', {'x', 'y', 'zoom', 'angle'}, {0, 0, 1, 0})
    setCameraShader('game', 'mirror')

    --Mirror Repeat, this one is used for the camera bumps I use
    initShader('mirror2', 'mirrorRepeat', {'x', 'y', 'zoom', 'angle'}, {0, 0, 1, 0})
    setCameraShader('game', 'mirror2')
    setCameraShader('hud', 'mirror2')

    --Mirror Repeat, this one is for mirrorX and mirrorY events
    initShader('mirror-game', 'mirrorRepeat', {'x', 'y', 'zoom', 'angle'}, {0, 0, 1, 0})
    setCameraShader('game', 'mirror-game')

    --Greyscale
    initShader('grey', 'greyscale', {'strength'}, {0})
    setCameraShader('game', 'grey')
    setCameraShader('hud', 'grey')

    --Chromatic abberation
    initShader('ca', 'ca', {'strength'}, {0})
    setCameraShader('game', 'ca')
    setCameraShader('hud', 'ca')

    --Can be good for fading the screen in/out
    initShader('ColorOverride', 'ColorOverrideEffect', {'red', 'green', 'blue'}, {1, 1, 1}) --0 = black screen btw
    setCameraShader('game', 'ColorOverride')
    setCameraShader('hud', 'ColorOverride')

    --Bloom
    initShader('Bloom', 'bloom', {'effect', 'strength', 'contrast', 'brightness'}, {0.0, 0.0, 1.0, 0.0})
    setCameraShader('game', 'Bloom')
    setCameraShader('hud', 'Bloom')

    --Barrel blur version
    initShader('BarrelBlurEffect', 'BarrelBlurEffect', {'iTime', 'barrel', 'zoom', 'angle'}, {0, 0, 1, 0})
    setShaderBool('BarrelBlurEffect', 'doChroma', true)
    setCameraShader('game', 'BarrelBlurEffect')
    setCameraShader('hud', 'BarrelBlurEffect')

    --Blur
    initShader('BlurEffect', 'BlurEffect', {'strengthX', 'strengthY'}, {0, 0})
    setCameraShader('game', 'BlurEffect')
    setCameraShader('hud', 'BlurEffect')
    
    initShader('bars', 'bars', {'effect'}, {0})
    setCameraShader('game', 'bars')
end

function onUpdate(elapsed)
    if shadersEnabled then 
        setShaderProperty('heat', 'iTime', getSongPosition()*0.001*0.7)
    end
    
end

function onEvent(eventName, value1, value2)
    if not shadersEnabled then 
        return
    end
    if eventName == 'blackBars' then
        steps = tonumber(value2);
        time = stepCrochet * 0.001 * steps

        tweenShaderProperty('bars', 'effect', value1, time, 'cubeInOut')
    end

    if eventName == 'mirrorZoom' then
        steps = tonumber(value2);
        time = stepCrochet * 0.001 * steps

        tweenShaderProperty('mirror', 'zoom', value1, time, 'cubeInOut')
    end

    if eventName == 'mirrorRotate' then
		steps = tonumber(value2);
        time = stepCrochet * 0.001 * steps

        varNum = getShaderProperty('mirror', 'angle')
		if value1 == varNum then
			return
		else
			tweenShaderProperty('mirror', 'angle', value1, time, 'cubeOut')
		end
	end

    if eventName == 'mirrorAngle' then
		steps = tonumber(value2);
        time = stepCrochet * 0.001 * steps

		setShaderProperty('mirror', 'angle', value1)
		tweenShaderProperty('mirror', 'angle', 0, time, 'cubeOut')
	end

    if eventName == 'MirrorX' then
        steps = tonumber(value2);
        time = stepCrochet * 0.001 * steps

        tweenShaderProperty('mirror-game', 'x', value1, time, 'cubeOut')
    end

    if eventName == 'MirrorY' then
        steps = tonumber(value2);
        time = stepCrochet * 0.001 * steps

        tweenShaderProperty('mirror-game', 'y', value1, time, 'cubeOut')
    end

    if eventName == 'mirrorBeat' then
        setShaderProperty('mirror2', 'zoom', 0.95)
        tweenShaderProperty('mirror2', 'zoom', 1, 0.4, 'cubeOut')
    end
    
    if eventName == 'barrelBlurBeat' then
        setShaderProperty('BarrelBlurEffect', 'barrel', 0.75)
        tweenShaderProperty('BarrelBlurEffect', 'barrel', 0, 0.3, 'cubeOut')
    end
	
    if eventName == 'BlurBeat' then
        setShaderProperty('BlurEffect', 'strengthX', 4.5)
        setShaderProperty('BlurEffect', 'strengthY', 4.5)
        tweenShaderProperty('BlurEffect', 'strengthX', 0, 0.4, 'cubeOut')
        tweenShaderProperty('BlurEffect', 'strengthY', 0, 0.4, 'cubeOut')
        setShaderProperty('mirror2', 'zoom', 0.95)
        tweenShaderProperty('mirror2', 'zoom', 1, 0.4, 'cubeOut')
        setShaderProperty('BarrelBlurEffect', 'barrel', 0.25)
        tweenShaderProperty('BarrelBlurEffect', 'barrel', 0, 0.3, 'cubeOut')
    end

    if eventName == 'FadeScreenIn' then
        steps = tonumber(value1);
        time = stepCrochet * 0.001 * steps

        tweenShaderProperty('ColorOverride', 'green', 0, time, 'cubeOut')
        tweenShaderProperty('ColorOverride', 'blue', 0, time, 'cubeOut')
        tweenShaderProperty('ColorOverride', 'red', 0, time, 'cubeOut')
    end

    if eventName == 'FadeScreenOut' then
        steps = tonumber(value1);
        time = stepCrochet * 0.001 * steps

        tweenShaderProperty('ColorOverride', 'green', 1, time, 'linear')
        tweenShaderProperty('ColorOverride', 'blue', 1, time, 'linear')
        tweenShaderProperty('ColorOverride', 'red', 1, time, 'linear')
    end

    if eventName == 'greyScale' then
        steps = tonumber(value2);
        time = stepCrochet * 0.001 * steps

        tweenShaderProperty('grey', 'strength', value1, time, 'linear')
    end

    if eventName == 'mosaic' then
        steps = tonumber(value2);
        time = stepCrochet * 0.001 * steps

        tweenShaderProperty('mosaic', 'strength', value1, time, 'cubeIn')
    end

    if eventName == 'bloomFlash' then
        steps = tonumber(value1);
        time = stepCrochet * 0.001 * steps

        setShaderProperty('Bloom', 'effect', 0.2)
        setShaderProperty('Bloom', 'strength', 0.5)

        tweenShaderProperty('Bloom', 'effect', 0, time, 'linear')
        tweenShaderProperty('Bloom', 'strength', 0, time, 'linear')
    end

    if eventName == 'chromBeat' then
        setShaderProperty('ca', 'strength', 0.005)

        tweenShaderProperty('ca', 'strength', 0, 0.4, 'linear')
    end
end