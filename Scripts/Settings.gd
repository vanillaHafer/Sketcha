extends Control

###################
#    Variables    #
###################

var song1 = preload("res://Audio/Song1.wav")
var song2 = preload("res://Audio/Song2.wav")
var song3 = preload("res://Audio/Song3.wav")

##################
# Ready Function #
##################

func _ready():
	$BGM.volume_db   = Singleton.BGMVolume
	$BGMVolume.value = Singleton.BGMVolume
	$SFXVolume.value = Singleton.SFXVolume
	randomize()
	
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

func _on_backButton_pressed():
	$SFX2.play()
	Singleton.songPosition = $BGM.get_playback_position()
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_HSlider_value_changed(value):
	Singleton.BGMVolume = value
	$BGM.volume_db = Singleton.BGMVolume

func _on_SFXVolume_value_changed(value):
	Singleton.SFXVolume = value
	$SFX1.volume_db = Singleton.SFXVolume
	$SFX2.volume_db = Singleton.SFXVolume
	$SFX3.volume_db = Singleton.SFXVolume

func _on_testSFX1_pressed():
	$SFX1.play()

func _on_testSFX2_pressed():
	$SFX2.play()

func _on_testSFX3_pressed():
	$SFX3.play()

func _on_changeActions_pressed():
	Singleton.get_node("Bubble").play()
	Singleton.songPosition = $BGM.get_playback_position()
	get_tree().change_scene("res://Scenes/changeActions.tscn")

func _on_changeCharacters_pressed():
	Singleton.get_node("Bubble").play()
	Singleton.songPosition = $BGM.get_playback_position()
	get_tree().change_scene("res://Scenes/changeCharacters.tscn")

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
