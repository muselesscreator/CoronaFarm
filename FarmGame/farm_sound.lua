
function playSoundEffect(fn)
    local snd = audio.loadSound('sound/'..fn..'.mp3')
    snd = audio.play( snd )
    print(snd)
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
    audio.setVolume(thePlayer.soundEffectsVolume, {channel=snd})
    audio.setVolume(thePlayer.musicVolume, {channel = backgroundMusicChannel})
    saveTable(thePlayer, 'player.json')
end


function setMusicVolume( event )
    thePlayer.musicVolume = event.value / 100
    audio.setVolume(thePlayer.musicVolume, {channel = backgroundMusicChannel})
    saveTable(thePlayer, 'player.json')
end

function setSFXVolume( event )
    thePlayer.soundEffectsVolume = event.value / 100
    saveTable(thePlayer, 'player.json')
end