extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass
	# Called when the node is added to the scene for the first time.
	# Initialization here
	var pressureplate = find_node("pressureplate")
	var door = find_node("Door")
	pressureplate.connect('plate_on', door, "open")
	pressureplate.connect('plate_off', door, "close")
	pressureplate.connect("body_entered", self, "_on_pressureplate_body_entered", [pressureplate])

func _on_pressureplate_body_entered(body, origin):
	if body.get_name() == "Character":
		origin.toggle()
