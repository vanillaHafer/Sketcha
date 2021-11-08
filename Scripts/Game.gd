extends Control

	
###################
#    Variables    #
###################

var characterScramble = true
var actionScramble    = true
var timerGoing        = false
var timerPaused       = false
var totalTime         = 120
var timerSeconds      = totalTime
var x                 = 1
var xGrowing          = true

	
####################
# Preloaded Assets #
####################

var greyButton  = preload("res://Images/Buttons/ButtonDisabled.png")
var greenButton = preload("res://Images/Buttons/Button4.png")
var song1       = preload("res://Audio/Song1.wav")
var song2       = preload("res://Audio/Song2.wav")
var song3       = preload("res://Audio/Song3.wav")
	
##################
# Ready Function #
##################

func _ready():
	$BGM.volume_db = Singleton.BGMVolume
	$Warning.volume_db = Singleton.SFXVolume
	$TimeUp.volume_db = Singleton.SFXVolume
	$Go.volume_db = Singleton.SFXVolume
	$timeOut.volume_db = Singleton.SFXVolume
	$buttonPress.volume_db = Singleton.SFXVolume
	randomize()
	
	if(Singleton.songNumber == 1):
		$BGM.stream = song1
	elif(Singleton.songNumber == 2):
		$BGM.stream = song2
	elif(Singleton.songNumber == 3):
		$BGM.stream = song3
		
	$BGM.play(Singleton.songPosition)
	
	$Timer/oneMinute.texture_normal = greyButton
	$Timer/threeMinute.texture_normal = greyButton

####################
# Process Function #
####################

func _process(delta):
	if($Draw.disabled == false):
		if(xGrowing):
			x += .01
		else:
			x -= .01
		if(x >= 1.3 || x <= 1):
			xGrowing = !xGrowing
		$Beta.rect_scale = Vector2(x,x)
	if(actionScramble):
		$Action/actionLabel.text = Singleton.activeActionList[(randi() % Singleton.activeActionList.size())]
	if(characterScramble):
		$Character/characterLabel.text = Singleton.activeCharacterList[(randi() % Singleton.activeCharacterList.size())]

####################
# Signal Functions #
####################

func _on_actionChooser_pressed():
	$buttonPress.play()
	actionScramble = !actionScramble
	if(actionScramble):
		if(characterScramble):
			$Restart.disabled = true
		$Action/action.text = "Stop"
		$Timer/TimerStart.disabled = true
		$Draw.disabled = true
	else:
		$Restart.disabled = false
		$Action/action.text = "Start"
		if(characterScramble == false):
			$Timer/TimerStart.disabled = false
			$Draw.disabled = false

func _on_characterChooser_pressed():
	$buttonPress.play()
	characterScramble = !characterScramble
	if(characterScramble):
		if(actionScramble):
			$Restart.disabled = true
		$Character/character.text = "Stop"
		$Timer/TimerStart.disabled = true
		$Draw.disabled = true
	else:
		$Restart.disabled = false
		$Character/character.text = "Start"
		if(actionScramble == false):
			$Timer/TimerStart.disabled = false
			$Draw.disabled = false

func _on_Restart_pressed():
	$buttonPress.play()
	$Timer/TimerStart.disabled = true
	$Draw.disabled = true
	$Restart.disabled = true
	characterScramble = true
	actionScramble    = true
	$Character/character.text = "Stop"
	$Action/action.text       = "Stop"

func _on_Random_pressed():
	$buttonPress.play()
	$Timer/TimerStart.disabled = false
	$Draw.disabled = false
	$Restart.disabled = false
	characterScramble = false
	actionScramble    = false
	$Action/actionLabel.text         = Singleton.activeActionList[(randi() % Singleton.activeActionList.size())]
	$Character/characterLabel.text   = Singleton.activeCharacterList[(randi() % Singleton.activeCharacterList.size())]
	$Character/character.text = "Start"
	$Action/action.text       = "Start"

func timeRanOut():
	$Timer/RoundTimer.stop()
	timerSeconds = totalTime
	$TimeUp.play()
	
	$Action/actionChooser.disabled = false
	$Character/characterChooser.disabled = false
	$Restart.disabled = false
	$Random.disabled = false
	$Timer/TimerStart.disabled = true
	$Draw.disabled = true
	timerPaused = false
	timerGoing = false
	$Timer/startTimer.text = "START TIMER"
	$Timer/timeRemaining.text = str(timerSeconds)
	enableTimeSetting()
	
func _on_RoundTimer_timeout():
	timerSeconds -= 1
	if(timerSeconds > 0):
		if(timerSeconds == 30):
			$Warning.play()
		$Timer/timeRemaining.text = str(timerSeconds)
	elif(timerSeconds <= 0):
		$Timer/timeRemaining.text = str(timerSeconds)
		timeRanOut()

func _on_TimerStart_pressed():
	$buttonPress.play()
	if(timerGoing == false):
		$Go.play()
		disableTimeSetting()
		$Action/actionChooser.disabled = true
		$Character/characterChooser.disabled = true
		$Restart.disabled = true
		$Random.disabled = true
		$Timer/RoundTimer.start(1)
		timerGoing = true
		timerSeconds = totalTime
		$Timer/timeRemaining.text = str(timerSeconds)
		$Timer/startTimer.text = "PAUSE TIMER"
	else:
		# Timer is now paused
		if(timerPaused == false):
			$timeOut.play()
			$Timer/cancelClock.disabled = false
			timerPaused = true
			$Timer/RoundTimer.stop()
			$Timer/startTimer.text = "START TIMER"
			$Timer/resetClock.disabled = false
		# Timer is now resumed
		else:
			$Go.play()
			$Timer/cancelClock.disabled = true
			timerPaused = false
			disableTimeSetting()
			$Timer/RoundTimer.start(1)
			$Timer/startTimer.text = "PAUSE TIMER"
			$Timer/resetClock.disabled = true

func _on_TimeUp_finished():
	$TimeUp.stop()

func _on_resetClock_pressed():
	$buttonPress.play()
	timerSeconds = totalTime
	$Timer/timeRemaining.text = str(timerSeconds)
	enableTimeSetting()

func _on_oneMinute_pressed():
	$buttonPress.play()
	totalTime = 60
	timerSeconds = 60
	$Timer/oneMinute.texture_normal = greenButton
	$Timer/twoMinute.texture_normal = greyButton
	$Timer/threeMinute.texture_normal = greyButton
	$Timer/timeRemaining.text = str(timerSeconds)

func _on_twoMinute_pressed():
	$buttonPress.play()
	totalTime = 120
	timerSeconds = 120
	$Timer/oneMinute.texture_normal = greyButton
	$Timer/twoMinute.texture_normal = greenButton
	$Timer/threeMinute.texture_normal = greyButton
	$Timer/timeRemaining.text = str(timerSeconds)

func _on_threeMinute_pressed():
	$buttonPress.play()
	totalTime = 180
	timerSeconds = 180
	$Timer/oneMinute.texture_normal = greyButton
	$Timer/twoMinute.texture_normal = greyButton
	$Timer/threeMinute.texture_normal = greenButton
	$Timer/timeRemaining.text = str(timerSeconds)

func _on_cancelClock_pressed():
	$buttonPress.play()
	timerGoing = false
	timerPaused = false
	enableTimeSetting()
	$Restart.disabled = false
	$Random.disabled = false
	$Action/actionChooser.disabled = false
	$Character/characterChooser.disabled = false
	$Timer/TimerStart.disabled = true
	$Draw.disabled = true
	$Timer/resetClock.disabled = true
	$Timer/cancelClock.disabled = true
	timerSeconds = totalTime
	$Timer/timeRemaining.text = str(timerSeconds)

func _on_Button_pressed():
	$buttonPress.play()
	$PopUp.queue_free()

func _on_exitButton_pressed():
	$buttonPress.play()
	$ConfirmationDialog.popup()
	get_tree().paused = true

func _on_ConfirmationDialog_confirmed():
	$buttonPress.play()
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_ConfirmationDialog_popup_hide():
	$buttonPress.play()
	get_tree().paused = false
	$exitButton.release_focus()

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

func _on_Draw_pressed():
	Singleton.character = $Character/characterLabel.text
	Singleton.action = $Action/actionLabel.text
	Singleton.timerSetting = totalTime
	get_tree().change_scene("res://Scenes/drawingTest.tscn")

func _on_Warning_finished():
	$Warning.stop()

####################
# Custom Functions #
####################
	
func disableTimeSetting():
	$Timer/oneMinute.disabled = true
	$Timer/oneMinute.modulate = Color(1,1,1,.25)
	$Timer/twoMinute.disabled = true
	$Timer/twoMinute.modulate = Color(1,1,1,.25)
	$Timer/threeMinute.disabled = true
	$Timer/threeMinute.modulate = Color(1,1,1,.25)
	
func enableTimeSetting():
	$Timer/oneMinute.disabled = false
	$Timer/oneMinute.modulate = Color(1,1,1,1)
	$Timer/twoMinute.disabled = false
	$Timer/twoMinute.modulate = Color(1,1,1,1)
	$Timer/threeMinute.disabled = false
	$Timer/threeMinute.modulate = Color(1,1,1,1)
