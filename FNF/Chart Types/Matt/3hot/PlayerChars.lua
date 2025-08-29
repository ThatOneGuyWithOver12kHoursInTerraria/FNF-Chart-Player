function onCreatePost()

    generateIcon('iconP3', 'icon-darnell', false)
    setProperty('iconP2.x', getProperty('iconP2.x')+40)
    setProperty('iconP2.y', getProperty('iconP2.y')+20)
    setProperty('iconP3.x', getProperty('iconP2.x')-80)
    setProperty('iconP3.y', getProperty('iconP2.y')-40)
    setProperty('iconP3.alpha', getProperty('iconP2.alpha'))
    setProperty('iconP3.visible', getProperty('iconP2.visible'))
end

function generateIcon(name, icon, isPlayer)
    createInstance(name, "objects.HealthIcon", {icon, isPlayer})
    callMethod('uiGroup.insert', {3, instanceArg(name)})
end

function onUpdatePost()
    setProperty('iconP3.animation.curAnim.curFrame', getProperty('iconP2.animation.curAnim.curFrame'))
    setProperty('iconP3.scale.x', getProperty('iconP2.scale.x'))
    setProperty('iconP3.scale.y', getProperty('iconP2.scale.y'))
    updateHitbox('iconP3')
end