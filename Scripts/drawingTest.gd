extends Control

###################
#    Variables    #
###################

var _pen            = null
var _prev_mouse_pos = Vector2()
var penSize         = 7
var penColor        = Color(255)
var penShape        = "circle"
var countdown       = 3
var canDraw         = false
var timeRemaining   = Singleton.timerSetting
var viewport

####################
# Preloaded Assets #
####################

var song1               = preload("res://Audio/Song1.wav")
var song2               = preload("res://Audio/Song2.wav")
var song3               = preload("res://Audio/Song3.wav")
var blackCircle         = preload("res://Images/DrawingTools/blackCircle.png")
var blackCircleSelected = preload("res://Images/DrawingTools/blackCircleSelected.png")
var blackSquare         = preload("res://Images/DrawingTools/blackSquare.png")
var blackSquareSelected = preload("res://Images/DrawingTools/blackSquareSelected.png")
var whiteSquare         = preload("res://Images/DrawingTools/whiteSquare.png")
var whiteSquareSelected = preload("res://Images/DrawingTools/whiteSquareSelected.png")
var thick               = preload("res://Images/DrawingTools/thick.png")
var thickSelected       = preload("res://Images/DrawingTools/thickSelected.png")
var thin                = preload("res://Images/DrawingTools/thin.png")
var thinSelected        = preload("res://Images/DrawingTools/thinSelected.png")


####################
#  Ready Function  #
####################

func _ready():
	 $character.text = Singleton.character
	 $action.text = Singleton.action
	 if(Singleton.firstTimeDrawing == false):
		 $PopUp.queue_free()
		 Singleton.get_node("Bubble").play()
		 $startingTimer.start(1)
	 Singleton.firstTimeDrawing = false
	 $BGM.volume_db = Singleton.BGMVolume
	 $Warning.volume_db = Singleton.SFXVolume
	 $TimeUp.volume_db = Singleton.SFXVolume
	 $Go.volume_db = Singleton.SFXVolume
	 $timeOut.volume_db = Singleton.SFXVolume
	 randomize()
	
	 if(Singleton.songNumber == 1):
		 $BGM.stream = song1
	 elif(Singleton.songNumber == 2):
		 $BGM.stream = song2
	 elif(Singleton.songNumber == 3):
		 $BGM.stream = song3
		
	 $BGM.play(Singleton.songPosition)
	 $timeRemaining.text = str(timeRemaining)
	 $blackSquare.texture_normal = blackSquareSelected
	 $thinLine.texture_normal    = thinSelected
	 $circleButton.texture_normal = blackCircleSelected
	 viewport = Viewport.new()
	 var rect = get_rect()
	 viewport.size = Vector2(1024,486.5)
	 viewport.usage = Viewport.USAGE_2D
	 viewport.render_target_clear_mode = Viewport.CLEAR_MODE_ONLY_NEXT_FRAME
	 viewport.render_target_v_flip = true

	 _pen = Node2D.new()
	 viewport.add_child(_pen)
	 _pen.connect("draw", self, "_on_draw")
	 viewport.set_transparent_background(true)
	 add_child(viewport)

	 var rt = viewport.get_texture()
	 var board = TextureRect.new()
	 board.set_texture(rt)
	 add_child(board)


####################
# Process Function #
####################

func _process(delta):
	 _pen.update()

####################
# Signal Functions #
####################

func _on_draw():
	 var mouse_pos = get_local_mouse_position()

	 if Input.is_mouse_button_pressed(BUTTON_LEFT) && canDraw:
		 if(penShape == "circle"):
			 _pen.draw_circle(mouse_pos, penSize, penColor)
		 elif(penShape == "square"):
			 _pen.draw_rect(Rect2(mouse_pos.x,mouse_pos.y,penSize,penSize), penColor, true)

	 _prev_mouse_pos = mouse_pos

func _on_blackSquare_pressed():
	penColor = Color(255)
	$blackSquare.texture_normal = blackSquareSelected
	$whiteSquare.texture_normal = whiteSquare

func _on_whiteSquare_pressed():
	penColor = Color(255,255,255)
	$blackSquare.texture_normal = blackSquare
	$whiteSquare.texture_normal = whiteSquareSelected

func _on_clearButton_pressed():
	viewport.render_target_clear_mode = Viewport.CLEAR_MODE_ONLY_NEXT_FRAME

func _on_thinLine_pressed():
	$thinLine.texture_normal    = thinSelected
	$thickLine.texture_normal   = thick
	penSize = 7

func _on_thickLine_pressed():
	$thinLine.texture_normal    = thin
	$thickLine.texture_normal   = thickSelected
	penSize = 15

func _on_circleButton_pressed():
	penShape = "circle"
	$squareButton.texture_normal = blackSquare
	$circleButton.texture_normal = blackCircleSelected

func _on_squareButton_pressed():
	penShape = "square"
	$squareButton.texture_normal = blackSquareSelected
	$circleButton.texture_normal = blackCircle

func _on_startingTimer_timeout():
	if(countdown == 0):
		$startingTimer.queue_free()
		$countdownLabel.queue_free()
		$Panel.queue_free()
	else:
		countdown -= 1
		if(countdown != 0):
			$countdownLabel.text = str(countdown) + "..."
			Singleton.get_node("Bubble").play()
			if(countdown == 1):
				$GoTimer.start(.5)
		else:
			$countdownLabel.text = "GO!"
			canDraw = true
			$actualTimer.start(1)

func _on_actualTimer_timeout():
	timeRemaining -= 1
	if(timeRemaining == 30):
		$Warning.play()
	if(timeRemaining == 0):
		$TimeUp.play()
		$actualTimer.stop()
		canDraw = false
		$clearButton.disabled = true
	$timeRemaining.text = str(timeRemaining)

func _on_Return_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")

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

func _on_okay_pressed():
	$PopUp.queue_free()
	Singleton.get_node("Bubble").play()
	$startingTimer.start(1)

func _on_GoTimer_timeout():
	$Go.play()
