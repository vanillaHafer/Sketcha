extends TextureButton

##################
#    Variable    #
##################

var isDisabled = false

####################
# Preloaded Assets #
####################

var disabledTexture = preload("res://Images/Buttons/ButtonDisabled.png")
var activeTexture = preload("res://Images/Buttons/Button4.png")

##################
# Ready Function #
##################

func _ready():
	if(isDisabled):
		$Label.modulate = Color(1,1,1,.4)
		texture_normal = disabledTexture
	if($Label.text.length() <= 19):
		$Label.rect_position += Vector2(0,25)

###################
# Signal Function #
###################

func _on_characterChanger_pressed():
	Singleton.get_node("Bubble").play()
	# Enable the word
	if(isDisabled):
		Singleton.activeCharacterList.append($Label.text)
		Singleton.disabledCharacterList.erase($Label.text)
		isDisabled = false
		$Label.modulate = Color(1,1,1,1)
		texture_normal = activeTexture
	# Disable the word
	else:
		Singleton.activeCharacterList.erase($Label.text)
		Singleton.disabledCharacterList.append($Label.text)
		isDisabled = true
		$Label.modulate = Color(1,1,1,.4)
		texture_normal = disabledTexture
