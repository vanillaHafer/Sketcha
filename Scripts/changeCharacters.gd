extends Control

####################
# Preloaded Assets #
####################

var characterChanger = preload("res://Scenes/characterChanger.tscn")
var song1            = preload("res://Audio/Song1.wav")
var song2            = preload("res://Audio/Song2.wav")
var song3            = preload("res://Audio/Song3.wav")

##################
# Ready Function #
##################

func _ready():
	# Set the volumes
	$BGM.volume_db = Singleton.BGMVolume
	$SFX.volume_db = Singleton.SFXVolume
	
	# Select the current song
	if(Singleton.songNumber == 1):
		$BGM.stream = song1
	elif(Singleton.songNumber == 2):
		$BGM.stream = song2
	elif(Singleton.songNumber == 3):
		$BGM.stream = song3
		
	# Play the current song from last known position
	$BGM.play(Singleton.songPosition)
	
	Singleton.sortAllCharacters()
	for character in Singleton.activeCharacterList:
		var actnBtn = characterChanger.instance()
		actnBtn.get_node("Label").text = character
		$ScrollContainer/VBoxContainer.add_child(actnBtn)
		actnBtn.rect_scale.x = 0.1
		actnBtn.rect_scale.y = 0.1
	for character in Singleton.disabledCharacterList:
		var actnBtn = characterChanger.instance()
		actnBtn.isDisabled = true
		actnBtn.get_node("Label").text = character
		$ScrollContainer/VBoxContainer.add_child(actnBtn)
		actnBtn.rect_scale.x = 0.1
		actnBtn.rect_scale.y = 0.1

####################
# Signal Functions #
####################

func _on_backButton_pressed():
	Singleton.get_node("Bubble").play()
	Singleton.songPosition = $BGM.get_playback_position()
	get_tree().change_scene("res://Scenes/Settings.tscn")

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

func _on_LineEdit_text_changed(new_text):
	Singleton.get_node("Bubble").play()
	$characters.text = str(new_text.length()) + "/30"

func _on_clearCharacter_pressed():
	Singleton.get_node("Bubble").play()
	$LineEdit.text = ""
	$characters.text = "0/30"

func _on_AddCharacter_pressed():
	Singleton.get_node("Bubble").play()
	if($LineEdit.text == ""):
		$errorTimer.start(3)
		$ERROR.visible = true
		$empty.visible = true
		$duplicate.visible = false	
		$Success.visible = false
	elif($LineEdit.text in Singleton.activeCharacterList):
		$errorTimer.start(3)
		$ERROR.visible = true
		$empty.visible = false
		$duplicate.visible = true
		$Success.visible = false
	else:
		$ERROR.visible = false
		$empty.visible = false
		$duplicate.visible = false
		$Success.visible = true
		$successTimer.start(3)
		Singleton.activeCharacterList.append($LineEdit.text)
		var actnBtn = characterChanger.instance()
		actnBtn.get_node("Label").text = $LineEdit.text
		$ScrollContainer/VBoxContainer.add_child(actnBtn)
		actnBtn.rect_scale.x = 0.1
		actnBtn.rect_scale.y = 0.1
		$scrollTimer.start(.2)
		$LineEdit.text = ""
		$characters.text = "0/30"

func _on_errorTimer_timeout():
	$ERROR.visible = false
	$empty.visible = false
	$duplicate.visible = false

func _on_successTimer_timeout():
	$Success.visible = false

func _on_scrollTimer_timeout():
	$ScrollContainer.scroll_vertical = 99999
