extends Control

onready var bg = $TextureRect
onready var continue_button = $Continue
onready var title = $Title
onready var home = $Home
onready var quit = $Quit
onready var transition = $Transition
onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	title.text = "You beat level " + str(LevelManager.CURRENT_LEVEL - 1) + "! \nContinue to the next level?"
	continue_button.connect("pressed", self, "on_continueButton_pressed")
	home.connect("pressed", self, "on_homeButton_pressed")
	quit.connect("pressed", self, "on_quitButton_pressed")

func on_continueButton_pressed():
	title.hide()
	continue_button.hide()
	home.hide()
	quit.hide()
	transition.transition_to("res://scenes/level"+str(LevelManager.CURRENT_LEVEL)+"/Level"+str(LevelManager.CURRENT_LEVEL)+".tscn")

func on_homeButton_pressed():
	title.hide()
	continue_button.hide()
	home.hide()
	quit.hide()
	transition.transition_to("res://scenes/menu_screens/main_screen/MainScreen.tscn")

func on_quitButton_pressed():
	animation_player.play("quit")
	yield(animation_player, "animation_finished")
	get_tree().quit()
