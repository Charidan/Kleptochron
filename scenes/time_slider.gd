extends HSlider
signal pause

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const UPP_DISTANCE = 600

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	self.connect("value_changed", self, "timeskip")

func timeskip(val):
	print('haha')
	emit_signal("pause")
	# TODO ask global to travel us back to the time
	print("UPP = " + str(global.furthest_present - UPP_DISTANCE) + " beach = " + str(global.furthest_present) + " target = " + str(lerp(global.furthest_present - UPP_DISTANCE, global.furthest_present, val)))
	global.time_travel_back(lerp(global.furthest_present - UPP_DISTANCE, global.furthest_present, val), get_tree().get_root().get_children()[len(get_tree().get_root().get_children()) - 1].get_children())