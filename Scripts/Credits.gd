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
	$BGM.volume_db = Singleton.BGMVolume
	$SFX.volume_db = Singleton.SFXVolume
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
	$SFX.play()
	Singleton.songPosition = $BGM.get_playback_position()
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

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
