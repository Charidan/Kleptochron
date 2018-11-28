extends MarginContainer

var button_jump
var button_pause
var button_play
var time_slider

func _ready():
	time_slider = find_node("time_slider")
	button_jump = find_node("button_jump")
	button_pause = find_node("button_pause")
	button_play = find_node("button_play")
	
	time_slider.focus_mode = Control.FOCUS_NONE
	button_jump.focus_mode = Control.FOCUS_NONE
	button_pause.focus_mode = Control.FOCUS_NONE
	button_play.focus_mode = Control.FOCUS_NONE
	
	time_slider.connect("pause", self, "pause")
	button_jump.connect("pressed", self, "jump")
	button_pause.connect("pressed", self, "pause")
	button_play.connect("pressed", self, "play")

#return to present and unpause
func play():
	print("played")
	global.time_travel(global.furthest_present, global.find_children())
	unpause()

#wipe futures and unpause
func jump():
	print("jump")
	global.jump(global.find_children())
	unpause()

func pause():
	print("paused")
	button_pause.disabled = true
	button_play.disabled = false
	button_play.pressed = false
	get_tree().paused = true

func unpause():
	print("unpaused")
	button_pause.disabled = false
	button_play.disabled = true
	button_pause.pressed = false
	get_tree().paused = false