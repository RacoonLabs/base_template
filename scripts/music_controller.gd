extends Node
 
var background_music = preload("res://assets/audio/background_music.wav")
var music: AudioStreamPlayer2D
var ready_to_play = true
const MUTE = -72
	
func play_background():
	music = AudioStreamPlayer2D.new()
	music.stream = background_music
	add_child(music)
	music.set_bus("Background")
	music.volume_db = -12
	music.play()
	ready_to_play = false

func toggle_background_music():
	if music.volume_db == MUTE:
		music.volume_db = -12
	else:
		music.volume_db = -72
	
