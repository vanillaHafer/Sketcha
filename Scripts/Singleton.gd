extends Node

###################
#    Variables    #
###################

var songNumber
var songPosition = 0
var BGMVolume    = -8
var SFXVolume    = 1
var character = "character"
var action    = "action"
var timerSetting = 5
var firstTimeDrawing = true

####################
#   Dictionaries   #
####################

var activeCharacterList = [
	"Mickey Mouse",
	"Naruto",
	"Spongebob",
	"Kirby",
	"Mario",
	"Link",
	"A Chicken",
	"Pikachu",
	"Rapunzel",
	"Flynn Rider",
	"Bugs Bunny",
	"Charlie Brown",
	"Darth Vader",
	"Superman",
	"Batman",
	"Peter Pan",
	"Spiderman",
	"Winnie the Pooh",
	"Popeye",
	"Yoda",
	"Cinderella",
	"A Hippie",
	"A Businessman",
	"Santa Claus",
	"Donald Trump",
	"Barney",
	"Yoshi",
	"A Clown",
	"A Ghost",
	"A Snowman",
	"Lightning McQueen",
	"A baby",
	"Hello Kitty",
	"Shrek",
	"A minion",
	"A secret agent",
	"Tony the Tiger",
	"Cap'n Crunch"
]

var disabledCharacterList = [
]

var activeActionList = [
	"Dancing",
	"Drowning",
	"Whistling a tune",
	"Punching something",
	"Doing the splits",
	"Hunting an animal",
	"Balancing on one leg",
	"Sword Fighting",
	"Canoeing",
	"Counting sheep",
	"Cutting onions",
	"Stepping on a lego",
	"Camping",
	"Snowboarding",
	"Flying through the sky",
	"Waving",
	"Mining",
	"Swimming",
	"Cooking up a meal",
	"Camping",
	"Texting",
	"Scaling a large mountain",
	"Purchasing a new car",
	"Binge-watching Disney+",
	"Sitting on a toilet",
	"Speeding",
	"Shopping",
	"Babysitting",
	"Cleaning",
	"At the beach",
	"In love",
	"Smelling flowers",
	"Getting a makeover",
	"At the park",
	"At the gym",
	"Stealing something valuable",
	"At the fair",
	"Playing video games"
]

var disabledActionList = [
]

####################
#  Ready Function  #
####################

func _ready():
	randomize()
	sortAlphabetically(activeActionList)
	sortAlphabetically(activeCharacterList)
	songNumber = (randi() % 3) + 1

####################
# Custom Functions #
####################

func sortAlphabetically(stringArray):
	var tempAction
	var currentWord
	var sortedList = stringArray
	for outer in range(0, sortedList.size()):
		for inner in range(0, sortedList.size()):
			if(sortedList[inner].to_lower() > sortedList[outer].to_lower()):
				tempAction = sortedList[inner]
				sortedList[inner] = sortedList[outer]
				sortedList[outer] = tempAction
		pass
	return stringArray
	
func sortAllLists():
	sortAlphabetically(activeActionList)
	sortAlphabetically(activeCharacterList)
	sortAlphabetically(disabledActionList)
	sortAlphabetically(disabledCharacterList)
	
func sortAllActions():
	sortAlphabetically(activeActionList)
	sortAlphabetically(disabledActionList)
	
func sortAllCharacters():
	sortAlphabetically(activeCharacterList)
	sortAlphabetically(disabledCharacterList)
