extends Control

####################
# Preloaded Assets #
####################

var song1 = preload("res://Audio/Song1.wav")
var song2 = preload("res://Audio/Song2.wav")
var song3 = preload("res://Audio/Song3.wav")

##################
# Ready Function #
##################

func _ready():
	
	$BGM.volume_db = Singleton.BGMVolume
	$SFX.volume_db = Singleton.SFXVolume
	
	if(Singleton.songNumber == 1):
		$BGM.stream = song1
	elif(Singleton.songNumber == 2):
		$BGM.stream = song2
	elif(Singleton.songNumber == 3):
		$BGM.stream = song3
		
	$BGM.play(Singleton.songPosition)
	
####################
# Signal Functions #
####################

func _on_Play_pressed():
	$SFX.play()
	Singleton.songPosition = $BGM.get_playback_position()
	get_tree().change_scene("res://Scenes/Game.tscn")

func _on_Settings_pressed():
	$SFX.play()
	Singleton.songPosition = $BGM.get_playback_position()
	get_tree().change_scene("res://Scenes/Settings.tscn")
		
func _on_Credits_pressed():
	$SFX.play()
	Singleton.songPosition = $BGM.get_playback_position()
	get_tree().change_scene("res://Scenes/Credits.tscn")
	
func _on_Quit_pressed():
	$SFX.play()
	get_tree().quit()

func _on_BGM_finished():
	var temp = (randi() % 3) + 1
	while(temp == Singleton.songNumber):
		temp = (randi() % 3) + 1
		
	Singleton.songNumber = temp
	if(Singleton.songNumber == 1):
		$BGM.stream = song1
	elif(Singleton.songNumber == 2):
		$BGM.stream = song2
	elif(Singleton.songNumber == 3):
		$BGM.stream = song3
		
	$BGM.play()
