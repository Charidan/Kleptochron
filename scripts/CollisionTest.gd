extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	global.reset_time()
	# Called when the node is added to the scene for the first time.
	# Initialization here
	var pp1 = find_node("PP_Door1")
	var pp2 = find_node("PP_Door2")
	var timeplate = find_node("PP_Time")
	var door = find_node("Door")
	pp1.connect('plate_on', door, "open")
	pp1.connect('plate_off', door, "close")
	
	pp2.connect('plate_on', door, "open")
	pp2.connect('plate_off', door, "close")
	
	pp1.connect('plate_on', pp2, "set_on")
	pp1.connect('plate_off', pp2, "set_off")
	
	pp2.connect('plate_on', pp2, "set_on")
	pp2.connect('plate_off', pp2, "set_off")
	
	pp1.connect('plate_on', pp1, "set_on")
	pp1.connect('plate_off', pp1, "set_off")
	
	pp2.connect('plate_on', pp1, "set_on")
	pp2.connect('plate_off', pp1, "set_off")
	
	pp1.connect("body_entered", self, "_on_pressureplate_body_entered", [pp1])
	pp2.connect("body_entered", self, "_on_pressureplate_body_entered", [pp2])
	
	timeplate.connect("body_entered", self, "_on_pressureplate_body_entered", [timeplate])
	

func _on_pressureplate_body_entered(body, origin):
	if body.get_name() == "Character":
		origin.toggle()
