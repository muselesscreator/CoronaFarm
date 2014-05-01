
function playSoundEffect(fn)
    local snd = audio.loadSound('sound/'..fn..'.wav')
    snd = audio.play( snd )
    print(snd)
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
    audio.setVolume(sfxVolume, {channel=snd})
end


function setMusicVolume( event )
    musicVolume = event.value / 100
    audio.setVolume(musicVolume, {channel = backgroundMusicChannel})
end

function setSFXVolume( event )
    sfxVolume = event.value / 100
    print(sfxVolume)
end