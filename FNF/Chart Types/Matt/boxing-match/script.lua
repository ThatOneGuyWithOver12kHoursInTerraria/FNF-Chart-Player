
function onCreate()
    callMethod("preloadMidSongVideo", {"BM_midcutscene"})
end

function onStepHit()
    if curStep == 1536 then
        callMethod("playMidSongVideo", {0})
    end
end