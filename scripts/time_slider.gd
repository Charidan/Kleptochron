extends HSlider
signal pause

var suppress_signal = false

func _ready():
	self.focus_mode = Control.FOCUS_NONE
	self.connect("value_changed", self, "timeskip")

func _physics_process(delta):
	suppress_signal = true
	set_time(global.time)
	suppress_signal = false

func get_slider_time(val = null):
	var v = val if val else value
	return int(lerp(global.furthest_present - global.UPP_DISTANCE, global.furthest_present, v))
	
#TODO make sure that the UPP doesn't move when you jump or reset the slider for any reason
# also investigate if the slider was resetting itself without the set_time function
func set_time(time):
	var upp = global.furthest_present - global.UPP_DISTANCE
	if not suppress_signal:
		print("SET TIME target_time = " + str(time) + " target_value = " + str(float(time - upp) / (global.furthest_present - upp)) + " beach = " + str(global.furthest_present) + " upp = " + str(upp))
	suppress_signal = true
	value = float(time - upp) / (global.furthest_present - upp)
	suppress_signal = false

func timeskip(val):
	if suppress_signal:
		return
	emit_signal("pause")
	print("UPP = " + str(global.furthest_present - global.UPP_DISTANCE) + " beach = " + str(global.furthest_present) + " target = " + str(lerp(global.furthest_present - global.UPP_DISTANCE, global.furthest_present, val)))
	#lerp between furthest_present anchor and UPP to get target time
	#subtract target time from current time to get delta
	global.time_travel(get_slider_time(val), global.find_children())