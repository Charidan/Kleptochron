extends MarginContainer

# class member variables go here, for example:
var button_jump
var button_pause
var button_play
var time_slider

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	time_slider = find_node("time_slider")
	button_jump = find_node("button_jump")
	button_pause = find_node("button_pause")
	button_play = find_node("button_play")
	
	time_slider.connect("pause", self, "pause")
	button_jump.connect("pause", self, "pause")
	button_pause.connect("pressed", self, "pause")
	button_play.connect("pressed", self, "unpause")

func pause():
	print("paused")
	button_pause.disabled = true
	button_play.disabled = false
	get_tree().paused = true

func unpause():
	print("played")
	button_pause.disabled = false
	button_play.disabled = true
	global.furthest_present = global.time
	time_slider.value = 1
	get_tree().paused = false